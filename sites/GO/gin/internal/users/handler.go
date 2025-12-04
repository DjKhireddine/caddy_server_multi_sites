package users

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	svc Service
}

func NewHandler(s Service) *Handler {
	return &Handler{svc: s}
}

func (h *Handler) RegisterRoutes(r *gin.RouterGroup) {
	r.POST("/register", h.register)
}

type credentials struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

func (h *Handler) register(c *gin.Context) {
	var input credentials
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.svc.Register(c.Request.Context(), input.Email, input.Password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"user": gin.H{
			"id":    user.ID,
			"email": user.Email,
		},
	})
}
