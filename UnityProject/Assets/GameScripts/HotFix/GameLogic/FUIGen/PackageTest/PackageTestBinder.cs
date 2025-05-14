/** This is an automatically generated class by FairyGUI. Please do not modify it. **/

using FairyGUI;

namespace PackageTest
{
    public class PackageTestBinder
    {
        public static void BindAll()
        {
            UIObjectFactory.SetPackageItemExtension(UI_SampleUI.URL, typeof(UI_SampleUI));
            UIObjectFactory.SetPackageItemExtension(UI_TestUI.URL, typeof(UI_TestUI));
        }
    }
}