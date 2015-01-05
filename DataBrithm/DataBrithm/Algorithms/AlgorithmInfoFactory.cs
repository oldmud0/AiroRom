﻿//
//  AlgorithmInfoFactory.cs
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
using System.Xml.Linq;

namespace DataBrithm
{
	public static class AlgorithmInfoFactory
	{
		public static AlgorithmInfo FromType(string type)
		{
			return FromType((AlgorithmType)Enum.Parse(typeof(AlgorithmType), type));
		}

		public static AlgorithmInfo FromType(AlgorithmType type)
		{
			switch (type) {
			case AlgorithmType.Encryption:
				return new EncryptionAlgorithm();

			case AlgorithmType.Compression:
				return new CompressionAlgorithm();

			case AlgorithmType.Integrity:
				return new IntegrityAlgorithm();

			default:
				throw new FormatException("Unsupported type");
			}
		}
	}
}

