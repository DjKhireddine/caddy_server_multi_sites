package events

import (
	"context"
)

type Service interface {
	List(ctx context.Context) ([]Event, error)
	Get(ctx context.Context, id int64) (*Event, error)
	Create(ctx context.Context, e *Event) error
	Update(ctx context.Context, e *Event) error
	Delete(ctx context.Context, id int64) error
}

type service struct {
	repo Repository
}

func NewService(r Repository) Service {
	return &service{repo: r}
}

func (s *service) List(ctx context.Context) ([]Event, error) {
	return s.repo.GetAll(ctx)
}

func (s *service) Get(ctx context.Context, id int64) (*Event, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *service) Create(ctx context.Context, e *Event) error {
	// Exemple : tu pourrais ajouter des validations métier ici
	if e.UserID == 0 {
		e.UserID = 1 // user “demo” par défaut
	}
	return s.repo.Create(ctx, e)
}

func (s *service) Update(ctx context.Context, e *Event) error {
	return s.repo.Update(ctx, e)
}

func (s *service) Delete(ctx context.Context, id int64) error {
	return s.repo.Delete(ctx, id)
}
