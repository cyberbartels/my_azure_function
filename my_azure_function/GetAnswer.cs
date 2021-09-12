using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

using de.cyberbartels.logic;

namespace de.cyberbartels.test
{
    public static class GetAnswer
    {
        [FunctionName("GetAnswer")]
        public static async Task<IActionResult> Ask(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string query = req.Query["query"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            query = query ?? data?.query;

            string responseMessage = string.IsNullOrEmpty(query)
                ? "This HTTP triggered function executed successfully. Pass a query in the query string or in the request body for a personalized response."
                : $"No answer to the query query \"{query}?\" available here.";

            return new OkObjectResult(responseMessage);
        }

        [FunctionName("Add")]
        public static async Task<IActionResult> Add(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "add")] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            int a;
            int b;
            try
            {
                a = Int32.Parse(req.Query["a"]);
                b = Int32.Parse(req.Query["b"]);
            }
            catch (System.Exception)
            {
                return new BadRequestResult();
            }    

            Calc calc = new Calc(a, b);
            int result = calc.Add();

            string responseMessage = $"\"result\": \"{result.ToString()}\"";

            return new OkObjectResult(responseMessage);
        }
    }
}
