using FairyGUI;
using System.Collections.Generic;
using PackageTest;
namespace GameLogic
{
    public class UIPage_Sample : FUIBase
    {
        UI_SampleUI ui;
        Dictionary<int, int> savConfigItem = new Dictionary<int, int>();

        protected override void OnInit()
        {
            base.OnInit();
            ui = this.contentPane as UI_SampleUI;
            this.uiShowType = UIShowType.SCREEN;
        }

        protected override void OnShown()
        {
            base.OnShown();
        }

        public override void Refresh(object param)
        {
            base.Refresh(param);
        }

        protected override void OnHide()
        {
            base.OnHide();

        }

        void OnClickBtnBack()
        {
            GameModule.UI.HideUI(this);
        }

        protected override void OnUpdate()
        {
            base.OnUpdate();
        }
    }
}