using Microsoft.AspNetCore.Mvc;
using PlcTagList_API.Models;
using PlcComm;
using Microsoft.EntityFrameworkCore;

namespace PlcTagList_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TagsController : ControllerBase
    {
        private readonly PlcComm.Tags.BrowseTags _plcBrowser;

        public TagsController()
        {
            _plcBrowser = new PlcComm.Tags.BrowseTags();
        }


        [HttpGet("GetTags")]
        public async Task<IActionResult> GetTags([FromQuery] string ipAddress, [FromQuery] string slot)
        {
            if (string.IsNullOrEmpty(ipAddress) || string.IsNullOrEmpty(slot))
            {
                return BadRequest("IP Address and Slot number are required.");
            }

            using (var context = new PlcContext())
            {
                var existingTags = await context.tags
                    .Where(t => t.ipaddress == ipAddress && t.slot == slot)
                    .ToListAsync();

                if (existingTags.Any())
                {
                    return Ok(existingTags);
                }

                try
                {
                    var tags = await _plcBrowser.BrowseControllerTagsAsync(ipAddress, slot);
                    context.tags.AddRange(tags.Select<PlcComm.DataTypes.TagDetail, Models.Tags>(t => new Models.Tags { name = t.Tagname, datatype = t.Datatype, ipaddress = ipAddress, slot = slot }));
                    await context.SaveChangesAsync();

                    return Ok(tags);
                }
                catch (Exception ex)
                {
                    return StatusCode(500, "An error occurred while fetching tags: " + ex.Message);
                }
            }
        }

        [HttpGet("GetStoredTags")]
        public async Task<IActionResult> GetStoredTags([FromQuery] string ipAddress, [FromQuery] string slot)
        {
            using (var context = new PlcContext())
            {
                var tags = await context.tags
                    .Where(t => t.ipaddress == ipAddress && t.slot == slot)
                    .ToListAsync();

                return Ok(tags);
            }
        }

    }
}
