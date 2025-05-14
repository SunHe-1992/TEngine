/** This is an automatically generated class by FairyGUI. Please do not modify it. **/

using FairyGUI;
using FairyGUI.Utils;

namespace PackageTest
{
    public partial class UI_SampleUI : GComponent
    {
        public GButton btn_test;
        public const string URL = "ui://eq79zy7jb8o83";

        public static UI_SampleUI CreateInstance()
        {
            return (UI_SampleUI)UIPackage.CreateObject("PackageTest", "SampleUI");
        }

        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            btn_test = (GButton)GetChild("btn_test");
        }
    }
}