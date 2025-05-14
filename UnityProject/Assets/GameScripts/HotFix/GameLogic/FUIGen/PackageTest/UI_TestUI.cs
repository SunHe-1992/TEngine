/** This is an automatically generated class by FairyGUI. Please do not modify it. **/

using FairyGUI;
using FairyGUI.Utils;

namespace PackageTest
{
    public partial class UI_TestUI : GComponent
    {
        public GButton btn_test;
        public const string URL = "ui://eq79zy7jq1re0";

        public static UI_TestUI CreateInstance()
        {
            return (UI_TestUI)UIPackage.CreateObject("PackageTest", "TestUI");
        }

        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            btn_test = (GButton)GetChild("btn_test");
        }
    }
}