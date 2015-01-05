﻿//
//  CompressionAlgorithm.cs
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
namespace DataBrithm
{
	public class CompressionAlgorithm : AlgorithmInfo
	{
		public CompressionAlgorithm()
		{
			Type = AlgorithmType.Compression;
		}

		public double CompressionRatio { get; set; }
		public double BalancedCompressionRatio { get; set; }

		public bool SupportsSubFiles { get; set; }
		public double AverageSubFiles { get; set; }
		public bool SupportsInmediateAccess { get; set; }

		public bool IsHeaderEncrypted { get; set; }
		public bool IsSubFilesEncrypted { get; set; }
		public int[] EncryptionAlgorithms { get; set; }
	}

}

