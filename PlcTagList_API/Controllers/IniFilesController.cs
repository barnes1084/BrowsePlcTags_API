using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Linq;

namespace PlcTagList_API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class IniFilesController : ControllerBase
    {
        [HttpGet("filenames")]   //  Test:  C:/Log
        public IActionResult GetIniFileNames(string directoryPath)
        {
            if (!Directory.Exists(directoryPath))
            {
                return NotFound("Directory not found.");
            }

            var iniFiles = Directory.GetFiles(directoryPath, "*.ini").Select(Path.GetFileName).ToList();
            return Ok(iniFiles);
        }

        [HttpGet("contents")]   //  Test:  C:/Log/example.ini
        public IActionResult GetIniFileContents(string filePath)
        {
            if (!System.IO.File.Exists(filePath))
            {
                return NotFound("File not found.");
            }

            var fileContents = new Dictionary<string, Dictionary<string, string>>();
            var currentSection = "";
            foreach (var line in System.IO.File.ReadAllLines(filePath))
            {
                if (line.StartsWith("[") && line.EndsWith("]"))
                {
                    currentSection = line.Trim(new char[] { '[', ']' });
                    fileContents[currentSection] = new Dictionary<string, string>();
                }
                else
                {
                    var keyValue = line.Split('=');
                    if (keyValue.Length == 2)
                    {
                        fileContents[currentSection][keyValue[0].Trim()] = keyValue[1].Trim();
                    }
                }
            }

            return Ok(fileContents);
        }

        [HttpPost("update")]   //  Test:  C:/Log/example.ini
        public IActionResult UpdateIniFileContents(string filePath, [FromBody] Dictionary<string, Dictionary<string, string>> newContents)
        {
            if (!System.IO.File.Exists(filePath))
            {
                return NotFound("File not found.");
            }

            try
            {
                using (var writer = new StreamWriter(filePath, false))
                {
                    foreach (var section in newContents)
                    {
                        writer.WriteLine($"[{section.Key}]");
                        foreach (var entry in section.Value)
                        {
                            writer.WriteLine($"{entry.Key}={entry.Value}");
                        }
                        writer.WriteLine(); 
                    }
                }
                return Ok("File updated successfully.");
            }
            catch (System.Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [HttpPost("create")]
        public IActionResult CreateIniFile(string filePath, [FromBody] Dictionary<string, Dictionary<string, string>> contents)
        {
            if (System.IO.File.Exists(filePath))
            {
                return BadRequest("File already exists.");
            }

            try
            {
                using (var writer = new StreamWriter(filePath))
                {
                    foreach (var section in contents)
                    {
                        writer.WriteLine($"[{section.Key}]");
                        foreach (var entry in section.Value)
                        {
                            writer.WriteLine($"{entry.Key}={entry.Value}");
                        }
                        writer.WriteLine();
                    }
                }
                return Ok("File created successfully.");
            }
            catch (System.Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }
    }
}

