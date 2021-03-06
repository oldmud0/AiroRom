﻿//
//  CompressionFrame.Designer.cs
//
//  Author:
//       Benito Palacios Sánchez <benito356@gmail.com>
//
//  Copyright (c) 2015 Benito Palacios Sánchez
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
using Xwt;

namespace DataBrithm
{
	public partial class CompressionFrame
	{
		Table view;
		SpinButton ratioBtn;
		SpinButton ratioBalancedBtn;

		CheckBox supportSubfilesCheck;
		SpinButton avgSubfilesBtn;
		CheckBox supportDirectAccessCheck;

		CheckBox isHeaderEncryptedCheck;
		CheckBox areSubfilesEncryptedCheck;
		TextEntry algorithmUsedTxt;

		void CreateComponents()
		{
			view = new Table();
			view.Margin = 10;

			ratioBtn = new SpinButton {
				Digits = 2,
				IncrementValue = 5,
				MaximumValue = 100,
			};

			ratioBalancedBtn = new SpinButton {
				Digits = 2,
				MaximumValue = 100,
				Sensitive = false
			};

			avgSubfilesBtn = new SpinButton {
				Digits = 0,
				IncrementValue = 1,
				MaximumValue = 100000
			};

			supportSubfilesCheck      = new CheckBox("Support subfiles?");
			supportSubfilesCheck.WidthRequest = 195;
			supportDirectAccessCheck  = new CheckBox("Support direct access?");
			isHeaderEncryptedCheck    = new CheckBox("Is header encrypted?");
			areSubfilesEncryptedCheck = new CheckBox("Are subfiles encrypted?");
			algorithmUsedTxt = new TextEntry();

			// Add components
			view.Add(new Label("Ratio:"), 0, 0);
			view.Add(ratioBtn, 1, 0, hpos: WidgetPlacement.Start);

			view.Add(new Label("Balanced ratio:"), 2, 0);
			view.Add(ratioBalancedBtn, 3, 0, hpos: WidgetPlacement.Start);

			view.Add(supportSubfilesCheck, 0, 1, colspan: 2);
			view.Add(supportDirectAccessCheck, 2, 1, colspan: 2);

			view.Add(isHeaderEncryptedCheck, 0, 2, colspan: 2);
			view.Add(areSubfilesEncryptedCheck, 2, 2, colspan: 2);

			view.Add(new Label("# Subfiles:"), 0, 3);
			view.Add(avgSubfilesBtn, 1, 3, hpos: WidgetPlacement.Start);

			view.Add(new Label("Algorithms used:"), 2, 3);
			view.Add(algorithmUsedTxt, 3, 3, hexpand: true);
		}
	}
}

