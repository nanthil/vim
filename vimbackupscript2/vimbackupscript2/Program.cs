using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace vimbackupscript2
{
    class Program
    {
        static void Main()
        {
            //keep listening
            while (true)
            {
                //Build file watcher
                FileSystemWatcher watcher = new FileSystemWatcher();
                watcher.Path = "C:\\Program Files\\Git\\etc";
                watcher.NotifyFilter = NotifyFilters.LastWrite | NotifyFilters.FileName | NotifyFilters.LastWrite;

                //Get lates write time to see if it is out of sync 
                //(accounts for when program is not running)
                DateTime mostRecentSave = File.GetLastWriteTimeUtc(watcher.Path + "\\vimrc");
                string logPath = "C:\\Users\\nathan.rogers\\vimbackup\\log.csv";
                var logFile = File.ReadAllText(logPath).Split(',');
                DateTime latestLog = new DateTime();

                //Create a time range for comparison
                //This is what keeps files from writing when they are up to date
                DateTime start = new DateTime(mostRecentSave.Year, mostRecentSave.Month, mostRecentSave.Day, mostRecentSave.Hour, mostRecentSave.Minute - 1, 0);
                DateTime end = new DateTime(mostRecentSave.Year, mostRecentSave.Month, mostRecentSave.Day, mostRecentSave.Hour, mostRecentSave.Minute + 1, 0);
                DateTime.TryParse(logFile[logFile.Length - 1], out latestLog);

                //Write file if out of sync
                if (latestLog > start && latestLog < end)
                {
                    Console.WriteLine("don't write file");
                }
                else
                {
                    Console.WriteLine("{0} {1} {2}", latestLog, start, end);
                    Console.WriteLine("write file");
                }

                //Event handlers
                watcher.WaitForChanged(WatcherChangeTypes.All);
                watcher.Changed += new FileSystemEventHandler(OnChanged);
                watcher.WaitForChanged(WatcherChangeTypes.All);

                //Write to file
                if (logFile.Length == 0)
                {
                    File.WriteAllText(logPath, mostRecentSave.ToString("g"));
                }
                else
                {
                    File.AppendAllText(logPath, "," + mostRecentSave.ToString("g"));
                }
            }
        }

        private static void OnChanged(object source, FileSystemEventArgs e)
        {
            //write to log
            // Specify what is done when a file is changed, created, or deleted.
            Console.WriteLine("File: " + e.FullPath + " " + e.ChangeType);
            string pathToCopyTo = "C:\\Users\\nathan.rogers\\vimbackup\\vimrc";

            File.Copy(e.FullPath, pathToCopyTo, true);
        }
    }
}