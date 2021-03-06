﻿//
//  AlgorithmInfo.cs
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
using System;
using YAXLib;

namespace DataBrithm
{
	public enum Device {
		NintendoDS,
		PS1,
		PSP
	}

	public enum FileType {
		Generic,
		Text,

		Save,
		DLC,
	}

	public enum AlgorithmType {
		Encryption,
		Compression,
		Integrity
	}

	public abstract class AlgorithmInfo
	{
		const double InstructionNormalizer = 10;

		public string Name { get; set; }
		public int Id { get; set; }
		public int GameId  { get; set; }
		public string Company { get; set; }
		public Device Device { get; set; }

		public AlgorithmType Type { get; protected set; }
		public bool CanBeDetected { get; set; }
		public int  Instructions  { get; set; }
		public string BasedOn { get; set; }

		public int Files { get; set; }
		public FileType FileType { get; set; }
		public double   FileFrecuencyAccess { get; set; }

		public int BestAlgorithm { get; set; }
		public string Details { get; set; }

		[YAXDontSerialize]
		public abstract Xwt.Drawing.Image Icon { get; }

		public double Quality { 
			get {
				double filePoints  = Math.Sqrt(Files * FileFrecuencyAccess / 2);
				double codeQuality = (Instructions > 0) ? (InstructionNormalizer / Instructions) : 0;
				double extra = CanBeDetected ? 20 : 0;
				double specific = SpecificQuality;

				return extra + codeQuality + filePoints + specific;
			}
		}

		protected abstract double SpecificQuality { get; }
	}
}
