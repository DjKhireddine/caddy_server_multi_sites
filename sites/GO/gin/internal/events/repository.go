package events

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
)

type Repository interface {
	GetAll(ctx context.Context) ([]Event, error)
	GetByID(ctx context.Context, id int64) (*Event, error)
	Create(ctx context.Context, e *Event) error
	Update(ctx context.Context, e *Event) error
	Delete(ctx context.Context, id int64) error
}

type repo struct {
	db *sql.DB
}

func NewRepository(db *sql.DB) Repository {
	return &repo{db: db}
}

func (r *repo) GetAll(ctx context.Context) ([]Event, error) {
	rows, err := r.db.QueryContext(ctx,
		`SELECT id, name, description, location, date_time, user_id
         FROM events ORDER BY id DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var events []Event
	for rows.Next() {
		var e Event
		if err := rows.Scan(&e.ID, &e.Name, &e.Description, &e.Location, &e.DateTime, &e.UserID); err != nil {
			return nil, err
		}
		events = append(events, e)
	}
	return events, rows.Err()
}

func (r *repo) GetByID(ctx context.Context, id int64) (*Event, error) {
	var e Event
	err := r.db.QueryRowContext(ctx,
		`SELECT id, name, description, location, date_time, user_id
         FROM events WHERE id = ?`, id).
		Scan(&e.ID, &e.Name, &e.Description, &e.Location, &e.DateTime, &e.UserID)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, fmt.Errorf("event %d not found", id)
		}
		return nil, err
	}
	return &e, nil
}

func (r *repo) Create(ctx context.Context, e *Event) error {
	res, err := r.db.ExecContext(ctx,
		`INSERT INTO events (name, description, location, date_time, user_id)
         VALUES (?, ?, ?, ?, ?)`,
		e.Name, e.Description, e.Location, e.DateTime, e.UserID,
	)
	if err != nil {
		return err
	}
	id, err := res.LastInsertId()
	if err != nil {
		return err
	}
	e.ID = id
	return nil
}

func (r *repo) Update(ctx context.Context, e *Event) error {
	_, err := r.db.ExecContext(ctx,
		`UPDATE events
         SET name = ?, description = ?, location = ?, date_time = ?, user_id = ?
         WHERE id = ?`,
		e.Name, e.Description, e.Location, e.DateTime, e.UserID, e.ID,
	)
	return err
}

func (r *repo) Delete(ctx context.Context, id int64) error {
	res, err := r.db.ExecContext(ctx, `DELETE FROM events WHERE id = ?`, id)
	if err != nil {
		return err
	}
	n, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if n == 0 {
		return fmt.Errorf("event %d not found", id)
	}
	return nil
}
