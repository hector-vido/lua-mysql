-- charsets.lua

local charsets = {}

function charsets.by_name(name)
	for id in pairs(charsets.options) do
		local charset = charsets.options[id]
		if charset[1] == name or (charset[2] == name and charset[3]) then
			return id
		end
	end
	return nil
end

charsets.options = {
	[1] = {'big5_chinese_ci','big5',true},
	[2] = {'latin2_czech_cs','latin2',false},
	[3] = {'dec8_swedish_ci','dec8',true},
	[4] = {'cp850_general_ci','cp850',true},
	[5] = {'latin1_german1_ci','latin1',false},
	[6] = {'hp8_english_ci','hp8',true},
	[7] = {'koi8r_general_ci','koi8r',true},
	[8] = {'latin1_swedish_ci','latin1',true},
	[9] = {'latin2_general_ci','latin2',true},
	[10] = {'swe7_swedish_ci','swe7',true},
	[11] = {'ascii_general_ci','ascii',true},
	[12] = {'ujis_japanese_ci','ujis',true},
	[13] = {'sjis_japanese_ci','sjis',true},
	[14] = {'cp1251_bulgarian_ci','cp1251',false},
	[15] = {'latin1_danish_ci','latin1',false},
	[16] = {'hebrew_general_ci','hebrew',true},
	[18] = {'tis620_thai_ci','tis620',true},
	[19] = {'euckr_korean_ci','euckr',true},
	[20] = {'latin7_estonian_cs','latin7',false},
	[21] = {'latin2_hungarian_ci','latin2',false},
	[22] = {'koi8u_general_ci','koi8u',true},
	[23] = {'cp1251_ukrainian_ci','cp1251',false},
	[24] = {'gb2312_chinese_ci','gb2312',true},
	[25] = {'greek_general_ci','greek',true},
	[26] = {'cp1250_general_ci','cp1250',true},
	[27] = {'latin2_croatian_ci','latin2',false},
	[28] = {'gbk_chinese_ci','gbk',true},
	[29] = {'cp1257_lithuanian_ci','cp1257',false},
	[30] = {'latin5_turkish_ci','latin5',true},
	[31] = {'latin1_german2_ci','latin1',false},
	[32] = {'armscii8_general_ci','armscii8',true},
	[33] = {'utf8_general_ci','utf8',true},
	[34] = {'cp1250_czech_cs','cp1250',false},
	[35] = {'ucs2_general_ci','ucs2',true},
	[36] = {'cp866_general_ci','cp866',true},
	[37] = {'keybcs2_general_ci','keybcs2',true},
	[38] = {'macce_general_ci','macce',true},
	[39] = {'macroman_general_ci','macroman',true},
	[40] = {'cp852_general_ci','cp852',true},
	[41] = {'latin7_general_ci','latin7',true},
	[42] = {'latin7_general_cs','latin7',false},
	[43] = {'macce_bin','macce',false},
	[44] = {'cp1250_croatian_ci','cp1250',false},
	[45] = {'utf8mb4_general_ci','utf8mb4',true},
	[46] = {'utf8mb4_bin','utf8mb4',false},
	[47] = {'latin1_bin','latin1',false},
	[48] = {'latin1_general_ci','latin1',false},
	[49] = {'latin1_general_cs','latin1',false},
	[50] = {'cp1251_bin','cp1251',false},
	[51] = {'cp1251_general_ci','cp1251',true},
	[52] = {'cp1251_general_cs','cp1251',false},
	[53] = {'macroman_bin','macroman',false},
	[54] = {'utf16_general_ci','utf16',true},
	[55] = {'utf16_bin','utf16',false},
	[56] = {'utf16le_general_ci','utf16le',true},
	[57] = {'cp1256_general_ci','cp1256',true},
	[58] = {'cp1257_bin','cp1257',false},
	[59] = {'cp1257_general_ci','cp1257',true},
	[60] = {'utf32_general_ci','utf32',true},
	[61] = {'utf32_bin','utf32',false},
	[62] = {'utf16le_bin','utf16le',false},
	[63] = {'binary','binary',true},
	[64] = {'armscii8_bin','armscii8',false},
	[65] = {'ascii_bin','ascii',false},
	[66] = {'cp1250_bin','cp1250',false},
	[67] = {'cp1256_bin','cp1256',false},
	[68] = {'cp866_bin','cp866',false},
	[69] = {'dec8_bin','dec8',false},
	[70] = {'greek_bin','greek',false},
	[71] = {'hebrew_bin','hebrew',false},
	[72] = {'hp8_bin','hp8',false},
	[73] = {'keybcs2_bin','keybcs2',false},
	[74] = {'koi8r_bin','koi8r',false},
	[75] = {'koi8u_bin','koi8u',false},
	[77] = {'latin2_bin','latin2',false},
	[78] = {'latin5_bin','latin5',false},
	[79] = {'latin7_bin','latin7',false},
	[80] = {'cp850_bin','cp850',false},
	[81] = {'cp852_bin','cp852',false},
	[82] = {'swe7_bin','swe7',false},
	[83] = {'utf8_bin','utf8',false},
	[84] = {'big5_bin','big5',false},
	[85] = {'euckr_bin','euckr',false},
	[86] = {'gb2312_bin','gb2312',false},
	[87] = {'gbk_bin','gbk',false},
	[88] = {'sjis_bin','sjis',false},
	[89] = {'tis620_bin','tis620',false},
	[90] = {'ucs2_bin','ucs2',false},
	[91] = {'ujis_bin','ujis',false},
	[92] = {'geostd8_general_ci','geostd8',true},
	[93] = {'geostd8_bin','geostd8',false},
	[94] = {'latin1_spanish_ci','latin1',false},
	[95] = {'cp932_japanese_ci','cp932',true},
	[96] = {'cp932_bin','cp932',false},
	[97] = {'eucjpms_japanese_ci','eucjpms',true},
	[98] = {'eucjpms_bin','eucjpms',false},
	[99] = {'cp1250_polish_ci','cp1250',false},
	[101] = {'utf16_unicode_ci','utf16',false},
	[102] = {'utf16_icelandic_ci','utf16',false},
	[103] = {'utf16_latvian_ci','utf16',false},
	[104] = {'utf16_romanian_ci','utf16',false},
	[105] = {'utf16_slovenian_ci','utf16',false},
	[106] = {'utf16_polish_ci','utf16',false},
	[107] = {'utf16_estonian_ci','utf16',false},
	[108] = {'utf16_spanish_ci','utf16',false},
	[109] = {'utf16_swedish_ci','utf16',false},
	[110] = {'utf16_turkish_ci','utf16',false},
	[111] = {'utf16_czech_ci','utf16',false},
	[112] = {'utf16_danish_ci','utf16',false},
	[113] = {'utf16_lithuanian_ci','utf16',false},
	[114] = {'utf16_slovak_ci','utf16',false},
	[115] = {'utf16_spanish2_ci','utf16',false},
	[116] = {'utf16_roman_ci','utf16',false},
	[117] = {'utf16_persian_ci','utf16',false},
	[118] = {'utf16_esperanto_ci','utf16',false},
	[119] = {'utf16_hungarian_ci','utf16',false},
	[120] = {'utf16_sinhala_ci','utf16',false},
	[121] = {'utf16_german2_ci','utf16',false},
	[122] = {'utf16_croatian_ci','utf16',false},
	[123] = {'utf16_unicode_520_ci','utf16',false},
	[124] = {'utf16_vietnamese_ci','utf16',false},
	[128] = {'ucs2_unicode_ci','ucs2',false},
	[129] = {'ucs2_icelandic_ci','ucs2',false},
	[130] = {'ucs2_latvian_ci','ucs2',false},
	[131] = {'ucs2_romanian_ci','ucs2',false},
	[132] = {'ucs2_slovenian_ci','ucs2',false},
	[133] = {'ucs2_polish_ci','ucs2',false},
	[134] = {'ucs2_estonian_ci','ucs2',false},
	[135] = {'ucs2_spanish_ci','ucs2',false},
	[136] = {'ucs2_swedish_ci','ucs2',false},
	[137] = {'ucs2_turkish_ci','ucs2',false},
	[138] = {'ucs2_czech_ci','ucs2',false},
	[139] = {'ucs2_danish_ci','ucs2',false},
	[140] = {'ucs2_lithuanian_ci','ucs2',false},
	[141] = {'ucs2_slovak_ci','ucs2',false},
	[142] = {'ucs2_spanish2_ci','ucs2',false},
	[143] = {'ucs2_roman_ci','ucs2',false},
	[144] = {'ucs2_persian_ci','ucs2',false},
	[145] = {'ucs2_esperanto_ci','ucs2',false},
	[146] = {'ucs2_hungarian_ci','ucs2',false},
	[147] = {'ucs2_sinhala_ci','ucs2',false},
	[148] = {'ucs2_german2_ci','ucs2',false},
	[149] = {'ucs2_croatian_ci','ucs2',false},
	[150] = {'ucs2_unicode_520_ci','ucs2',false},
	[151] = {'ucs2_vietnamese_ci','ucs2',false},
	[159] = {'ucs2_general_mysql500_ci','ucs2',false},
	[160] = {'utf32_unicode_ci','utf32',false},
	[161] = {'utf32_icelandic_ci','utf32',false},
	[162] = {'utf32_latvian_ci','utf32',false},
	[163] = {'utf32_romanian_ci','utf32',false},
	[164] = {'utf32_slovenian_ci','utf32',false},
	[165] = {'utf32_polish_ci','utf32',false},
	[166] = {'utf32_estonian_ci','utf32',false},
	[167] = {'utf32_spanish_ci','utf32',false},
	[168] = {'utf32_swedish_ci','utf32',false},
	[169] = {'utf32_turkish_ci','utf32',false},
	[170] = {'utf32_czech_ci','utf32',false},
	[171] = {'utf32_danish_ci','utf32',false},
	[172] = {'utf32_lithuanian_ci','utf32',false},
	[173] = {'utf32_slovak_ci','utf32',false},
	[174] = {'utf32_spanish2_ci','utf32',false},
	[175] = {'utf32_roman_ci','utf32',false},
	[176] = {'utf32_persian_ci','utf32',false},
	[177] = {'utf32_esperanto_ci','utf32',false},
	[178] = {'utf32_hungarian_ci','utf32',false},
	[179] = {'utf32_sinhala_ci','utf32',false},
	[180] = {'utf32_german2_ci','utf32',false},
	[181] = {'utf32_croatian_ci','utf32',false},
	[182] = {'utf32_unicode_520_ci','utf32',false},
	[183] = {'utf32_vietnamese_ci','utf32',false},
	[192] = {'utf8_unicode_ci','utf8',false},
	[193] = {'utf8_icelandic_ci','utf8',false},
	[194] = {'utf8_latvian_ci','utf8',false},
	[195] = {'utf8_romanian_ci','utf8',false},
	[196] = {'utf8_slovenian_ci','utf8',false},
	[197] = {'utf8_polish_ci','utf8',false},
	[198] = {'utf8_estonian_ci','utf8',false},
	[199] = {'utf8_spanish_ci','utf8',false},
	[200] = {'utf8_swedish_ci','utf8',false},
	[201] = {'utf8_turkish_ci','utf8',false},
	[202] = {'utf8_czech_ci','utf8',false},
	[203] = {'utf8_danish_ci','utf8',false},
	[204] = {'utf8_lithuanian_ci','utf8',false},
	[205] = {'utf8_slovak_ci','utf8',false},
	[206] = {'utf8_spanish2_ci','utf8',false},
	[207] = {'utf8_roman_ci','utf8',false},
	[208] = {'utf8_persian_ci','utf8',false},
	[209] = {'utf8_esperanto_ci','utf8',false},
	[210] = {'utf8_hungarian_ci','utf8',false},
	[211] = {'utf8_sinhala_ci','utf8',false},
	[212] = {'utf8_german2_ci','utf8',false},
	[213] = {'utf8_croatian_ci','utf8',false},
	[214] = {'utf8_unicode_520_ci','utf8',false},
	[215] = {'utf8_vietnamese_ci','utf8',false},
	[223] = {'utf8_general_mysql500_ci','utf8',false},
	[224] = {'utf8mb4_unicode_ci','utf8mb4',false},
	[225] = {'utf8mb4_icelandic_ci','utf8mb4',false},
	[226] = {'utf8mb4_latvian_ci','utf8mb4',false},
	[227] = {'utf8mb4_romanian_ci','utf8mb4',false},
	[228] = {'utf8mb4_slovenian_ci','utf8mb4',false},
	[229] = {'utf8mb4_polish_ci','utf8mb4',false},
	[230] = {'utf8mb4_estonian_ci','utf8mb4',false},
	[231] = {'utf8mb4_spanish_ci','utf8mb4',false},
	[232] = {'utf8mb4_swedish_ci','utf8mb4',false},
	[233] = {'utf8mb4_turkish_ci','utf8mb4',false},
	[234] = {'utf8mb4_czech_ci','utf8mb4',false},
	[235] = {'utf8mb4_danish_ci','utf8mb4',false},
	[236] = {'utf8mb4_lithuanian_ci','utf8mb4',false},
	[237] = {'utf8mb4_slovak_ci','utf8mb4',false},
	[238] = {'utf8mb4_spanish2_ci','utf8mb4',false},
	[239] = {'utf8mb4_roman_ci','utf8mb4',false},
	[240] = {'utf8mb4_persian_ci','utf8mb4',false},
	[241] = {'utf8mb4_esperanto_ci','utf8mb4',false},
	[242] = {'utf8mb4_hungarian_ci','utf8mb4',false},
	[243] = {'utf8mb4_sinhala_ci','utf8mb4',false},
	[244] = {'utf8mb4_german2_ci','utf8mb4',false},
	[245] = {'utf8mb4_croatian_ci','utf8mb4',false},
	[246] = {'utf8mb4_unicode_520_ci','utf8mb4',false},
	[247] = {'utf8mb4_vietnamese_ci','utf8mb4',false},
	[248] = {'gb18030_chinese_ci','gb18030',true},
	[249] = {'gb18030_bin','gb18030',false},
	[250] = {'gb18030_unicode_520_ci','gb18030',false}
}

return charsets