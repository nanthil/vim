using System;
using System.Collections.Generic;
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
            while (true)
            {
                FileSystemWatcher watcher = new FileSystemWatcher();
                watcher.Path = "C:\\Program Files\\Git\\etc";
                watcher.NotifyFilter = NotifyFilters.LastWrite | NotifyFilters.FileName;
                watcher.Changed += new FileSystemEventHandler(OnChanged);

                watcher.WaitForChanged(WatcherChangeTypes.All);
            }
           
        }

        private static void OnChanged(object source, FileSystemEventArgs e)
        {
            // Specify what is done when a file is changed, created, or deleted.
            Console.WriteLine("File: " + e.FullPath + " " + e.ChangeType);
            string pathToCopyTo = "C:\\Users\\nathan.rogers\\vimbackup\\vimrc";
            File.Copy(e.FullPath, pathToCopyTo, true);
        }
    }
}