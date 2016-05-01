
namespace Sitecore.LinqScratchPadExtender
{
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Drawing;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Web;
    using Microsoft.CSharp;
    using System;

    public partial class LinqScratchPadExtender : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public static Tuple<string, IEnumerable<object>> CompileAndRun(string code, string assemblyList, string systemAssembly, string parameters, string mainClass, string methodStartUp)
        {
            var options = new CompilerParameters
            {
                GenerateInMemory = true,
                TreatWarningsAsErrors = false,
                GenerateExecutable = false,
                CompilerOptions = "/optimize"
            };

            var strArray1 = new[]
            {
                "System.dll",
                "System.Xml.dll",
                "mscorlib.dll",
                "System.Configuration.dll",
                "System.Core.dll"
            };

            var strArray2 = new[]
            {
                "Sitecore.Kernel.dll",
                "Sitecore.Buckets.dll",
                "Sitecore.ContentSearch.dll",
                "Sitecore.ContentSearch.Linq.dll"
            };

            for (var index = 0; index < strArray2.Length; ++index)
            {
                strArray2[index] = Path.Combine(Path.GetDirectoryName(HttpContext.Current.Request.PhysicalApplicationPath + "bin\\"), strArray2[index]);
            }

            if (systemAssembly.Length > 0)
            {
                var sysAssembly = systemAssembly.Replace(" ", string.Empty).Split(',');

                options.ReferencedAssemblies.AddRange(sysAssembly);
            }

            if (assemblyList.Length > 0)
            {
                var assemblyArray = assemblyList.Replace(" ", string.Empty).Split(',');

                for (var index = 0; index < assemblyArray.Length; ++index)
                {
                    assemblyArray[index] = Path.Combine(Path.GetDirectoryName(HttpContext.Current.Request.PhysicalApplicationPath + "bin\\"), assemblyArray[index].Trim());
                }

                options.ReferencedAssemblies.AddRange(assemblyArray);
            }

            options.ReferencedAssemblies.AddRange(strArray2);
            options.ReferencedAssemblies.AddRange(strArray1);

            var compilerResults = new CSharpCodeProvider().CompileAssemblyFromSource(options, code);

            if (compilerResults.Errors.HasErrors)
            {
                var str = compilerResults.Errors.Cast<CompilerError>()
                    .Aggregate("Compile error: ", (current, compilerError) => current + "rn" + compilerError);

                return new Tuple<string, IEnumerable<object>>(str, new List<object>());
            }

            ExploreAssembly(compilerResults.CompiledAssembly);

            var module = compilerResults.CompiledAssembly.GetModules()[0];

            var type = module.GetTypes().FirstOrDefault(x => x.FullName.Contains(mainClass));

            if (type == null)
            {
                return null;
            }
               
            var methodInfo = type.GetMethod(methodStartUp);

            if (!(methodInfo != null))
            {
                return new Tuple<string, IEnumerable<object>>("0", new List<object>());
            }

            var methodParameters = methodInfo.GetParameters();

            var stopwatch = new Stopwatch();

            var parametersObject = new object[methodParameters.Length];

            stopwatch.Start();

            if (parameters.Length > 0)
            {
                var paramList = parameters.Replace(" ", string.Empty).Split(',');

                for (var i = 0; i < methodParameters.Length; i++)
                {
                    var paramType = methodParameters[i].ParameterType;
                        
                    parametersObject[i] = Convert.ChangeType(paramList[i], paramType);
                }

                var enumerable = methodInfo.Invoke(null, parametersObject) as IEnumerable<object>;

                stopwatch.Stop();

                return new Tuple<string, IEnumerable<object>>(stopwatch.ElapsedMilliseconds.ToString(CultureInfo.InvariantCulture), enumerable);
            }
            else
            {
                var enumerable = methodInfo.Invoke(null, new object[]
                {

                }) as IEnumerable<object>;

                stopwatch.Stop();

                return new Tuple<string, IEnumerable<object>>(stopwatch.ElapsedMilliseconds.ToString(CultureInfo.InvariantCulture), enumerable);
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            try
            {
                var tuple = CompileAndRun
                    (
                        this.LinqQuery.Text,
                        this.AssemblyList.Text,
                        this.SystemAssembly.Text,
                        this.MethodParameters.Text,
                        this.MainClass.Text,
                        this.MethodStartUp.Text
                    );

                this.GridResults.DataSource = tuple.Item2;
                this.GridResults.DataBind();
                this.Output.Text = tuple.Item1 + "ms to run";
                this.Error.Text = string.Empty;
            }
            catch (Exception ex)
            {
                this.Error.ForeColor = Color.Red;
                this.Error.Text = string.Format("Message: {0}\n, InnerMessage: {1}\n, StackTrace: {2}", ex.Message, ex.InnerException, ex.StackTrace);
            }
        }

        private static void ExploreAssembly(Assembly assembly)
        {
            Console.WriteLine("Modules in the assembly:");
            foreach (Module module in assembly.GetModules())
            {
                Console.WriteLine("{0}", module);
                foreach (Type type in module.GetTypes())
                {
                    Console.WriteLine("t{0}", type.Name);
                    foreach (var memberInfo in type.GetMethods())
                    {
                        Console.WriteLine("tt{0}", memberInfo.Name);
                    }
                }
            }
        }
    }
}