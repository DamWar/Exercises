using System;

static class LogLine
{
    public static string Message(string logLine)
    {
        string find = "]:";
        int startFrom = logLine.IndexOf(find) + find.Length;
        string match = logLine.Substring(startFrom);
        return match.Trim();
    }

    public static string LogLevel(string logLine) 
    {
        string findBeginning = "[";
        string findEnd = "]:";
        int startFrom = logLine.IndexOf(findBeginning) + findBeginning.Length;
        int endAt = logLine.IndexOf(findEnd)-1;
        string match = logLine.Substring(startFrom, endAt);
        return match.ToLower();
    }

    public static string Reformat(string logLine)
    {
        return $"{LogLine.Message(logLine)} ({LogLine.LogLevel(logLine)})";
    }
}       