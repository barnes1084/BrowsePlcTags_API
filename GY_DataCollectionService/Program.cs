using InfluxDB.Client;
using InfluxDB.Client.Api.Domain;
using InfluxDB.Client.Writes;
using System.Net;
using Logix;
using PlcComm;


Tags.BrowseTags plc = new Tags.BrowseTags();
var list = await plc.BrowseControllerTagsAsync("10.69.46.13", "3");
Console.WriteLine("TypeName\t\tName");
foreach (var tag in list)
{
    Console.WriteLine($"{tag.Datatype}\t\t{tag.Tagname}");
}

Console.ReadKey();


////  Connect to the PLC
//LogixTcpClient plc = new LogixTcpClient(new IPEndPoint(IPAddress.Parse("10.69.46.13"), 44818), 1, 3);

////  Connect to the Influx DB
//InfluxDBClient influxDBClient = InfluxDBClientFactory.Create("http://localhost:8086", "my-super-secret-auth-token");

////  Let's set up some thread blocking.
//ManualResetEvent mre = new ManualResetEvent(false);

////  Create and start a 1 second timer that that opens the ReadTag function
//System.Threading.Timer timer = new Timer(state => ReadTag(), null, 0, 1000);

////  Create an event that detects when the app closes, so we can dispose properly.
//AppDomain.CurrentDomain.ProcessExit += (s, e) => { Close(); };

////  This blocks the thread from ending before the timer elapses.
//mre.WaitOne();


//void ReadTag()
//{
//    string tagname = "DT_Lv2RequestID";

//    var value = plc.ReadInt32(tagname);
//    WriteDataToInfluxDB(tagname, value).Wait();
//}

//async Task WriteDataToInfluxDB(string tagname, int value)
//{
//    var writeApi = influxDBClient.GetWriteApiAsync();
//    var point = PointData.Measurement("environment")
//                         .Tag("device", "sensor1")
//                         .Field(tagname, value)  // Assuming the value is temperature
//                         .Timestamp(DateTime.UtcNow, WritePrecision.Ns);

//    await writeApi.WritePointAsync(point, "my-bucket", "my-org");
//    Console.Clear();
//    Console.WriteLine($"{DateTime.UtcNow} - Value: {value}");
//}

//void Close()
//{
//    influxDBClient.Dispose();
//    plc.Dispose();
//    mre.Set();
//}