package users

import "time"

type User struct {
	ID           int64     `json:"id"`
	Email        string    `json:"email" binding:"required,email"`
	Password     string    `json:"password,omitempty" binding:"required,min=6"`
	PasswordHash string    `json:"-"` // never sent with JSON
	CreatedAt    time.Time `json:"created_at"`
}
