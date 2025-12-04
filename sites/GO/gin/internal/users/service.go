package users

import (
	"context"
	"fmt"

	"golang.org/x/crypto/bcrypt"
)

type Service interface {
	Register(ctx context.Context, email, password string) (*User, error)
}

type service struct {
	repo Repository
}

func NewService(r Repository) Service {
	return &service{repo: r}
}

// Register create user with password hash
func (s *service) Register(ctx context.Context, email, password string) (*User, error) {
	// hash
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("hash password: %w", err)
	}

	u := &User{
		Email:        email,
		PasswordHash: string(hash),
	}

	// save in db
	if err := s.repo.Create(ctx, u); err != nil {
		return nil, err
	}

	return u, nil
}
