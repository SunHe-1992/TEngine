using System.Collections.Generic;
public class FUIDef
{
    /// <summary>
    /// UI内容
    /// </summary>
    public enum FWindow
    {
        TestUI,
        SampleUI,
    }
    /// <summary>
    /// 包名
    /// </summary>
    public enum FPackage
    {
        PackageTest,
    }
    /// <summary>
    /// 界面变动
    /// </summary>
    public static Dictionary<FWindow, FPackage> windowUIpair = new Dictionary<FWindow, FPackage>()
    {
        { FWindow.TestUI, FPackage.PackageTest},
        { FWindow.SampleUI, FPackage.PackageTest},
    };

    /// <summary>
    /// 所有界面的binder
    /// </summary>
    public static void BindAll()
    {
        PackageTest.PackageTestBinder.BindAll();
    }
}