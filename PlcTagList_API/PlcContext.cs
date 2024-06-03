using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using PlcTagList_API.Models;

namespace PlcTagList_API
{
    public class PlcContext : DbContext
    {
        public DbSet<Tags> tags { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
            => optionsBuilder.UseNpgsql("Host=localhost;Database=plc_tags_db;Username=user;Password=password");
    }
}
