package models

type FullDocModel interface {
}

type DocModel struct {
	DID        int    `json:"did"`
	DNAME      string `json:"dname"`
	ABSTRACT   string `json:"abstract"`
	PUBLISHER  string `json:"publisher"`
	COVER_COST int    `json:"coverCost"`
}

type BookModel struct {
	AUTHOR string `json:"author"`
	BTYPE  string `json:"btype"`
	TYPE   string `json:"type"`
}

type MazModel struct {
	VOL       int    `json:"volumn"`
	HIGHLIGHT string `json:"highlight"`
	TYPE      string `json:"type"`
}

type ReportModel struct {
	NATION string `json:"nation"`
	FIELD  string `json:"field"`
	TYPE   string `json:"type"`
}