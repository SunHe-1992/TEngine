using FairyGUI;
using System.Collections.Generic;
using PackageTest;
using System;
using UnityEngine;
namespace GameLogic
{
    public class UIPage_Test : FUIBase
    {
        UI_TestUI ui;
        Dictionary<int, int> savConfigItem = new Dictionary<int, int>();

        protected override void OnInit()
        {
            base.OnInit();
            ui = this.contentPane as UI_TestUI;
            this.uiShowType = UIShowType.SCREEN;
            ui.btn_test.onClick.Set(OnBtnTestClick);
        }

        private void OnBtnTestClick(EventContext context)
        {
            Debug.Log("btn test click");
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