package libphonenumber

type RegionCodeAreaCodes struct {
	StartIndex int
	EndIndex   int
	Codes      []int
}

var CountryAreaCodeToRegion = map[string]RegionCodeAreaCodes{
	"KZ": {
		StartIndex: 1,
		EndIndex:   3,
		Codes: []int{710, 711, 712, 713, 714, 715, 716, 717, 718, 721,
			722, 723, 724, 725, 726, 727, 728, 729, 730, 700, 701, 702,
			705, 707, 708, 747, 760, 762, 763, 764, 771, 775, 776, 777,
			778, 785},
	},
}

// TODO: add any other country area codes here.