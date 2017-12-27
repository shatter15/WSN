
#include "Calculate.h"

module RandomSenderP
{
	uses interface Boot;
	uses interface Leds;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl;
	uses interface Timer<TMilli> as Timer0;
	uses interface Random;
	uses interface ParameterInit<uint16_t> as SeedInit;
	uses interface Read<uint16_t>;
}
implementation
{
	event void Boot.booted()
	{
		while(SUCCESS != call Read.read())
			;
	}

	event void Read.readDone(error_t result, uint16_t data)
	{
		call SeedInit.init(data);
		while(SUCCESS != call SplitControl.start())
			;
	}

	event void SplitControl.startDone(error_t err)
	{
		if(err != SUCCESS)
			call SplitControl.start();
		else
			call Timer0.startPeriodic(10);
	}

	event void SplitControl.stopDone(error_t err) { }

	message_t queue[12];
	int qh = 0, qt = 0;

	void queue_in(data_packge* dp)
	{
		if((qh+1)%12 == qt)
			return;
		memcpy(
			call Packet.getPayload(&queue[qh], sizeof(data_packge))
			, dp, sizeof(data_packge));
		qh = (qh+1)%12;
	}

	task void senddp()
	{
		if(SUCCESS != call
			AMSend.send(AM_BROADCAST_ADDR, &queue[qt], sizeof(data_packge))
			)
			post senddp();
	}

	uint16_t count = 0;
	uint32_t nums[2000] = {
		3268, 2301, 3112, 4437, 1877, 4493, 134, 966, 2959, 2601, 3441, 3869, 410, 3055, 3182, 2540, 2816, 4542, 4868, 3386, 2125, 4053, 1558, 3160, 3061, 3060, 794, 4119, 4629, 42, 4201, 157, 498, 2839, 2657, 446, 1259, 656, 3478, 2596, 951, 2949, 4608, 282, 4739, 308, 3268, 2472, 3097, 2753, 2815, 2224, 1375, 3412, 1149, 1180, 3037, 2514, 378, 3186, 690, 1306, 4430, 3732, 4350, 187, 255, 933, 3107, 3973, 1377, 3968, 1327, 339, 3701, 4905, 1116, 4681, 4736, 2888, 4436, 407, 2381, 1597, 4940, 614, 1738, 361, 424, 99, 1140, 2792, 1234, 1646, 3062, 3686, 4928, 4520, 894, 1265, 3241, 3166, 534, 2245, 1036, 4917, 1422, 2382, 2312, 4522, 4161, 896, 3796, 3365, 1303, 3497, 976, 3785, 3787, 597, 2661, 1818, 2244, 3311, 2088, 3664, 3217, 859, 4667, 3309, 3182, 2673, 2400, 1448, 1229, 993, 3659, 4179, 1661, 4331, 1190, 874, 3111, 4204, 2529, 4739, 4364, 792, 2352, 2145, 2747, 1113, 2913, 2047, 4926, 972, 4372, 4868, 3969, 4305, 3882, 3075, 4802, 4465, 3294, 756, 1248, 2454, 2557, 3694, 239, 4605, 4400, 4002, 1231, 3656, 3791, 219, 3556, 380, 1493, 3823, 143, 4472, 117, 349, 4819, 821, 2644, 4246, 3394, 4823, 4792, 4283, 637, 600, 1681, 1107, 2238, 3447, 1190, 2678, 2799, 474, 4733, 4296, 4185, 2970, 1389, 642, 134, 2626, 1403, 3473, 2132, 2717, 4643, 4222, 921, 1759, 3219, 4554, 3318, 1401, 4394, 4544, 528, 3350, 4708, 947, 1425, 738, 4529, 2376, 2097, 4341, 4246, 717, 3147, 2199, 359, 2182, 1803, 3430, 2955, 3421, 1622, 2822, 1619, 808, 563, 3472, 2932, 3772, 4334, 1685, 1428, 2844, 3480, 2705, 3865, 1429, 4367, 2353, 3756, 516, 4769, 908, 4588, 1524, 753, 4885, 3406, 1753, 3912, 4574, 732, 1276, 3268, 3987, 3723, 3924, 4729, 1340, 2428, 809, 1411, 398, 4920, 1436, 529, 801, 3312, 4484, 3911, 2614, 3006, 3186, 1356, 4678, 2114, 4480, 600, 1187, 2277, 719, 3335, 3192, 2520, 4455, 2785, 2820, 2162, 1680, 3421, 2510, 4072, 3688, 4776, 2023, 3955, 157, 4932, 3836, 4142, 1880, 2641, 3189, 1032, 1949, 297, 4929, 1610, 841, 2973, 2072, 4888, 818, 3418, 697, 2004, 763, 1624, 2347, 4347, 1311, 3372, 3339, 3256, 2093, 4723, 1859, 1885, 3146, 1113, 2883, 3756, 2587, 3344, 3399, 2675, 379, 1817, 4443, 4613, 1154, 4057, 4650, 2405, 1295, 257, 3003, 2999, 3753, 4462, 4717, 995, 2869, 717, 622, 1848, 736, 4855, 2887, 2460, 704, 3309, 4152, 2401, 2240, 2056, 4835, 790, 586, 4828, 3562, 499, 4005, 3409, 355, 2250, 2915, 294, 4954, 2689, 2275, 1095, 2173, 4670, 3649, 3919, 3381, 94, 3005, 4420, 3554, 2660, 774, 4028, 4461, 4060, 672, 3390, 4827, 781, 4376, 2602, 3895, 2029, 2393, 1159, 1723, 1904, 2508, 3920, 2004, 1293, 735, 4702, 3197, 4537, 3005, 1215, 1029, 170, 3589, 4940, 3449, 2103, 2680, 232, 4606, 969, 1490, 2240, 1853, 1250, 929, 575, 4217, 3901, 657, 2777, 2320, 2861, 240, 2056, 2182, 898, 1474, 897, 3439, 1591, 4246, 4727, 4112, 2391, 1095, 3138, 4288, 771, 3163, 710, 3696, 595, 3170, 225, 3873, 1424, 4660, 2484, 4938, 1714, 2509, 466, 3353, 12, 2319, 1792, 3036, 4521, 3253, 1931, 3911, 4314, 2952, 1901, 648, 1117, 3752, 3018, 3695, 2368, 4917, 2278, 1097, 2842, 3110, 4313, 1652, 3708, 4809, 1912, 2931, 3423, 4081, 202, 934, 3935, 389, 3439, 1067, 3116, 3830, 2963, 3103, 3314, 963, 4764, 1154, 3000, 3561, 794, 186, 2932, 1514, 572, 1035, 1128, 335, 2596, 2290, 3527, 3326, 2966, 3458, 791, 3308, 4329, 3594, 4140, 3061, 4946, 4865, 4345, 3149, 693, 4426, 1992, 2228, 2599, 2334, 987, 2069, 4256, 1760, 3892, 3174, 2851, 3187, 4822, 363, 4785, 2945, 378, 391, 3737, 4618, 1170, 1462, 3503, 1666, 1232, 2094, 4535, 4707, 3618, 4042, 1279, 3877, 2463, 2087, 2331, 4269, 4419, 17, 3423, 3993, 4183, 1567, 4270, 2435, 4081, 3370, 4605, 1694, 3255, 1231, 1213, 4912, 3612, 312, 2795, 4076, 4601, 2282, 2613, 2276, 1884, 481, 769, 2383, 1467, 3084, 3308, 4132, 4641, 4262, 3565, 1751, 443, 3176, 991, 157, 2790, 2957, 2740, 4500, 994, 4462, 2391, 2155, 805, 382, 3432, 4617, 4234, 2632, 2798, 4875, 1369, 4139, 3359, 100, 556, 1365, 816, 438, 2525, 1241, 2372, 977, 4671, 3266, 1902, 3660, 933, 1513, 4810, 4786, 1722, 1008, 1199, 1007, 1425, 3862, 2051, 555, 802, 1514, 4448, 4822, 1067, 4942, 1195, 4017, 4782, 3542, 672, 1235, 4599, 1602, 1643, 1200, 3022, 166, 1199, 2810, 2055, 311, 4626, 772, 1104, 863, 804, 459, 1639, 2483, 687, 2565, 1263, 3159, 2374, 438, 4011, 1950, 3705, 4372, 2485, 4854, 113, 4614, 2886, 579, 4899, 1895, 1062, 2037, 2390, 2193, 3773, 3254, 3867, 4425, 4200, 4029, 2505, 3339, 2783, 460, 844, 2541, 972, 3904, 4675, 4404, 2123, 3007, 2244, 1735, 2784, 4579, 166, 504, 1634, 488, 1147, 2901, 3366, 4206, 1630, 4319, 4240, 2086, 3943, 1727, 2999, 2831, 206, 2445, 2012, 1635, 4602, 3992, 2218, 1188, 1704, 3974, 4579, 709, 3531, 4413, 1806, 706, 3950, 3118, 4877, 950, 4301, 3576, 3719, 1580, 267, 3810, 3979, 4699, 1337, 3936, 3831, 1864, 1665, 3153, 2530, 2232, 93, 3952, 4910, 4851, 4614, 2336, 2134, 9, 3485, 4571, 334, 2113, 909, 1833, 39, 3925, 136, 4448, 889, 4419, 33, 3543, 2841, 4669, 2600, 443, 4249, 2770, 2645, 2819, 1024, 2069, 339, 3915, 3064, 4533, 4101, 1022, 3329, 4336, 1519, 1680, 1840, 3444, 1640, 3219, 4657, 1606, 2937, 3894, 4145, 2025, 1626, 2058, 563, 3507, 1343, 1001, 1135, 1369, 3667, 1223, 1766, 2903, 793, 2884, 2808, 1916, 1100, 4717, 393, 704, 3581, 4279, 2446, 2410, 4222, 2626, 74, 2416, 3549, 628, 1238, 3096, 2868, 2912, 3285, 1907, 3109, 4376, 3449, 4457, 4438, 893, 4323, 3292, 2240, 1071, 675, 1226, 2375, 4133, 4045, 206, 1129, 4395, 4462, 3979, 2067, 3311, 184, 3225, 2241, 2994, 4422, 3688, 4027, 3582, 3745, 2349, 2143, 2903, 3168, 3707, 2908, 1333, 2890, 240, 4603, 4720, 4642, 1072, 235, 2576, 4134, 1196, 2954, 887, 1764, 3231, 3266, 2913, 3380, 1704, 4787, 571, 467, 3914, 559, 1418, 4708, 3815, 2871, 657, 2405, 2840, 2139, 1851, 309, 2659, 3011, 4457, 1255, 1969, 2886, 1054, 2653, 223, 2029, 1378, 1476, 3240, 70, 888, 804, 3584, 2914, 3985, 3583, 4236, 756, 3759, 4837, 221, 3049, 3333, 1882, 4442, 894, 1097, 4645, 114, 1287, 1947, 2416, 629, 4222, 4392, 2648, 1068, 2144, 3165, 3537, 4905, 3262, 2436, 3935, 2391, 858, 1973, 3790, 4001, 4941, 4349, 928, 2941, 2869, 671, 4081, 3788, 4534, 2711, 4688, 149, 3709, 3935, 1494, 4816, 419, 636, 1076, 1002, 2718, 3248, 1183, 1050, 1758, 3240, 2766, 2203, 3553, 4426, 4220, 4194, 4375, 3986, 2908, 2185, 4780, 2433, 4118, 2721, 2247, 4158, 204, 4975, 516, 2243, 1414, 2650, 2252, 2219, 1775, 4291, 2498, 3767, 2075, 3372, 3371, 4517, 1978, 4511, 4345, 3315, 4977, 937, 3222, 676, 3000, 4402, 619, 2736, 1459, 2407, 2165, 3078, 606, 3937, 3448, 3975, 934, 1618, 4054, 3423, 1902, 1869, 3407, 592, 4317, 4527, 1780, 158, 4945, 4064, 2940, 3303, 4008, 2379, 4844, 1606, 4478, 4478, 1504, 798, 913, 1823, 835, 4313, 4639, 2506, 1262, 2882, 457, 3694, 2131, 3107, 2781, 1055, 576, 2061, 963, 776, 3475, 2400, 3105, 118, 3034, 3696, 1796, 4789, 3662, 3778, 4133, 4301, 2765, 4281, 2862, 3338, 2879, 2284, 2342, 4711, 1613, 3607, 1915, 3806, 357, 1732, 3659, 596, 2848, 2016, 4685, 2958, 388, 2641, 3456, 1488, 1964, 3624, 3965, 2263, 419, 3298, 2222, 3277, 750, 4550, 2871, 4020, 736, 4970, 1625, 1271, 60, 4008, 2640, 4969, 4653, 1248, 2243, 1183, 1070, 2716, 904, 1248, 703, 3547, 526, 3918, 706, 4414, 1105, 4880, 571, 3863, 664, 2561, 3579, 2232, 3484, 1783, 2352, 306, 1862, 4041, 623, 2038, 3146, 1830, 4793, 1410, 3220, 762, 1904, 0, 3366, 2465, 4150, 2600, 1376, 2498, 2805, 1507, 524, 2934, 4291, 3840, 1338, 3115, 364, 2915, 3827, 1327, 549, 859, 4084, 911, 121, 3785, 2767, 632, 3686, 3416, 3666, 1414, 3669, 27, 2397, 775, 1512, 2752, 487, 1825, 2360, 3604, 4115, 4069, 3911, 1512, 4423, 719, 3129, 510, 2377, 2405, 1353, 4741, 4710, 1295, 1087, 2445, 3532, 4175, 4064, 34, 3534, 3344, 3237, 1016, 3604, 2332, 1023, 1569, 4484, 4787, 3722, 1487, 190, 2138, 2399, 1484, 2824, 160, 4975, 1933, 4129, 3267, 4480, 4467, 573, 3073, 4954, 73, 3754, 820, 1765, 178, 2829, 1102, 1184, 2659, 2893, 2766, 438, 794, 3094, 4913, 2534, 4385, 590, 1409, 4250, 4010, 81, 3715, 350, 4988, 1480, 4950, 3563, 3741, 2000, 996, 2155, 2696, 4377, 2988, 2401, 2177, 2309, 457, 3696, 1128, 1220, 4887, 4336, 4282, 2707, 3119, 363, 2390, 1287, 426, 4919, 3473, 2121, 855, 4555, 4125, 4626, 3618, 195, 3656, 324, 3823, 2892, 2866, 2166, 3784, 2314, 3205, 4767, 3386, 161, 2795, 2619, 3488, 4706, 1022, 1746, 638, 534, 3361, 4575, 2236, 4874, 865, 1313, 686, 2517, 140, 1822, 477, 1216, 3070, 84, 2163, 3323, 2928, 2786, 603, 1774, 4508, 334, 2133, 4301, 2476, 3652, 3865, 4166, 3207, 3700, 2801, 188, 3389, 1492, 2171, 260, 1274, 4036, 2105, 469, 1584, 3004, 4071, 1784, 1679, 4372, 3320, 823, 2139, 4465, 2423, 1426, 3302, 2766, 2069, 1137, 785, 699, 985, 170, 1337, 450, 4594, 1169, 2349, 304, 1296, 482, 2750, 20, 660, 1484, 4920, 3885, 3492, 3236, 4508, 611, 4031, 3910, 4092, 32, 973, 4128, 4639, 427, 4508, 464, 415, 3956, 4227, 4719, 3255, 311, 2310, 1928, 759, 1005, 1328, 1857, 3494, 211, 1037, 207, 4378, 1745, 568, 2168, 4358, 694, 1347, 1932, 3103, 4869, 1493, 341, 275, 4590, 1477, 3896, 171, 3173, 3625, 3667, 476, 1276, 1453, 492, 4682, 318, 3776, 537, 1842, 2256, 3012, 3377, 489, 561, 2893, 1309, 2170, 4064, 1062, 4070, 2821, 1167, 3380, 3156, 1429, 495, 4299, 1718, 3112, 3074, 4321, 4964, 3722, 4890, 2585, 2973, 1910, 4073, 4299, 4544, 2632, 790, 2043, 4998, 3684, 3173, 4711, 1098, 2017, 1534, 2314, 1598, 809, 1779, 4171, 2398, 1755, 3468, 3286, 4699, 4917, 2409, 3276, 4494, 3784, 4603, 2606, 3486, 2133, 17, 1401, 4207, 4363, 4027, 3938, 2827, 514, 3093, 212, 2124, 4470, 2732, 2981, 4787, 4558, 3695, 2882, 1921, 4316, 3731, 1180, 2852, 3191, 2717, 3642, 319, 2295, 476, 2695, 3997, 4294, 4427, 1827, 1528, 241, 4515, 3027, 2544, 2353, 3416, 2290, 1884, 3850, 1679, 2647, 2910, 1324, 4140, 3747, 779, 187, 3706, 4212, 3094, 1087, 1484, 3275, 190, 1810, 3740, 3321, 4862, 1317, 3580, 1117, 2534, 3138, 1220, 63, 4353, 1569, 3652, 429, 3319, 4858, 2679, 2857, 716, 2890, 3747, 341, 3891, 4874, 4892, 4290, 1129, 1093, 841, 3978, 4944, 1425, 1469, 25, 893, 449, 3572, 3062, 3558, 1225, 457, 1576, 4012, 3592, 4038, 32, 4610, 4235, 1838, 1461, 3190, 2642, 2019, 398, 2143, 3293, 1065, 993, 4025, 1972, 4500, 935, 4826, 2147, 4504, 2188, 3117, 1758, 1087, 4879, 2238, 2791, 911, 1513, 2588, 4199, 3195, 2260, 190, 1958, 936, 943, 2579, 748, 4533, 317, 3914, 270, 542, 2701, 1569, 1856, 241, 4941, 629, 3957, 4306, 4256, 1294, 2811, 3012, 2039, 753, 1103, 4540, 3990, 279, 2761, 46, 4400, 634, 151, 1093, 1639, 1463, 1069, 4763, 493, 4754, 2301, 2008, 2149, 588, 2882, 896, 2779, 4674, 3728, 3653, 4134, 4791, 2493, 2016, 1725, 910, 4468, 3406, 4337, 1120, 3891, 1758, 3947, 711, 1912, 990, 3409, 3814, 688, 3398, 1785, 1010, 3312, 4697, 102, 4506, 202, 4401, 2714, 591, 2059, 1937, 3399, 802, 3983, 1886, 3305, 210, 760, 1186, 1960, 1500, 2941, 2648, 2177, 1819, 3704, 4015, 2122, 294, 2020, 4190, 4043, 4618, 123, 3524, 4848, 3363, 725, 4426, 2824, 2413, 2109, 4155, 4831, 1472, 2661, 103, 1293, 1533, 2314, 4776, 2082, 2007, 4889, 3757, 1702, 4112, 776, 1279, 419, 1233, 591, 413, 2299, 1793, 4271, 4196, 4393, 1319, 4875, 1571, 3578, 3104, 598, 954, 2549, 4891, 1108, 3020, 3644, 79, 2624, 4108, 4177, 1791, 1450, 4703, 361, 1315, 4430, 2253, 4786, 4435, 3904, 3710, 3184, 3119, 4469, 2373, 2279, 1751, 4852, 2760, 3737, 3875, 1695, 1644, 2425, 1136, 4252, 3541, 2313, 3545, 3095, 3412, 1431, 2998, 796, 315, 2269, 2327, 2127, 588, 381, 923, 3075, 2299, 3552, 4183, 3953, 4456, 2624, 2231, 2836, 3824, 4629, 3920, 936, 4259, 4833, 2873, 2602, 368, 1554, 656, 162, 3616, 2310, 625, 4572, 1926, 3848, 3394, 1267, 4225, 1333, 456, 1871, 3024, 1797, 3764, 2998, 3595, 723, 2643, 4359, 1927, 3407, 967, 721, 4220, 3642, 4822, 1826, 4970, 2147, 3708, 3292, 4964, 104, 3914, 2902, 534, 2246, 1450, 3159, 3805, 3764, 3675, 773
	};
	uint32_t seed = 1;

	event void Timer0.fired()
	{
		data_packge dp;
		dp.sequence_number = count%2000 + 1;
        //send from 1 ... 2000
		/*if(count < 2000)
		{
			nums[count] = seed % 5000;
			seed = seed + 1;
		}*/
		dp.random_integer = nums[count%2000];
		queue_in(&dp);
		post senddp();
		count++;
		if(count%100 == 0)
			call Leds.led0Toggle();
		if(count % 2000 == 0)
			call Leds.led1Toggle();
	}

	event void AMSend.sendDone(message_t* msg, error_t err)
	{
		if(msg == &queue[qt] && err == SUCCESS)
			qt = (qt+1)%12;
		if(qt != qh)
			post senddp();
	}
}
