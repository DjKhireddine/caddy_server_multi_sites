package events

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	svc Service
}

func NewHandler(s Service) *Handler {
	return &Handler{svc: s}
}

func (h *Handler) RegisterRoutes(r *gin.Engine) {
	events := r.Group("/events")
	{
		events.GET("", h.list)
		events.POST("", h.create)
		events.GET("/:id", h.get)
		events.PUT("/:id", h.update)
		events.DELETE("/:id", h.delete)
	}
}

func (h *Handler) list(c *gin.Context) {
	events, err := h.svc.List(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not fetch events"})
		return
	}
	c.JSON(http.StatusOK, events)
}

func (h *Handler) get(c *gin.Context) {
	id, err := parseID(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}

	event, err := h.svc.Get(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, event)
}

func (h *Handler) create(c *gin.Context) {
	var e Event
	if err := c.ShouldBindJSON(&e); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := h.svc.Create(c.Request.Context(), &e); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create event"})
		return
	}
	c.JSON(http.StatusCreated, e)
}

func (h *Handler) update(c *gin.Context) {
	id, err := parseID(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}
	var e Event
	if err := c.ShouldBindJSON(&e); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	e.ID = id
	if err := h.svc.Update(c.Request.Context(), &e); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update event"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "updated"})
}

func (h *Handler) delete(c *gin.Context) {
	id, err := parseID(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}
	if err := h.svc.Delete(c.Request.Context(), id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "deleted"})
}

func parseID(s string) (int64, error) {
	return strconv.ParseInt(s, 10, 64)
}
