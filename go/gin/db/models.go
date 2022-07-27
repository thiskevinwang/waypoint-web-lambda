package db

import "github.com/google/uuid"

// To exclude `id` from a serialized json response:
//
// Use gorm's db.Omit("id") to omit it from the DB query
//
// Set the `ID`` struct field as a pointer so that the
// zero-value will be `nil`, rather than `00000000-0000-0000-0000-000000000000`.
// This will serialize to JSON `null`.
//
// Add omitempty to the json struct tag. This signals to
// JSON serialization that we can omit keys with `null` values.
// ex. `... json:"[<key>,][optional,]omitempty"`
//
// This struct auto-migrates to:
// #	column_name		data_type	is_nullable	check	column_default
// ---------------------------------------------------------------------------
// 1	id				uuid		NO			NULL	gen_random_uuid()
// 2	batch_id		text		NO			NULL	NULL
// 3	timestamp_micro	int8		YES			NULL	NULL
// 4	weight_lb		numeric		YES			NULL	NULL
type Entry struct {
	ID             *uuid.UUID `gorm:"primary_key;type:uuid;default:gen_random_uuid()" json:"id,optional,omitempty"`
	BatchID        *string    `gorm:"index;not null;type:text" json:"batch_id,optional,omitempty"`
	TimestampMicro int        `json:"t"`
	WeightLb       float64    `json:"w"`
}
