package auth

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

const ContextUserIDKey = "userID"
const ContextUserEmailKey = "userEmail"

// AuthMiddleware check the bearer token JWT & set the context with the userID
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1) Get Authorization header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "authorization header required"})
			return
		}

		// 2) Check "Bearer <token>" format
		parts := strings.Fields(authHeader)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "bearer") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "authorization header format must be Bearer {token}"})
			return
		}
		tokenString := parts[1]

		// 3) Parse & validate the token
		token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(t *jwt.Token) (interface{}, error) {
			// compare used algo (HS256 expected)
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrTokenSignatureInvalid
			}
			return getSecret(), nil
		})
		if err != nil {
			// jwt returns different errors : can be validation error, expired, signature invalid...
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token", "details": err.Error()})
			return
		}

		// 4) Extract claims & set the context
		if claims, ok := token.Claims.(*Claims); ok && token.Valid {
			c.Set(ContextUserIDKey, claims.UserID)
			c.Set(ContextUserEmailKey, claims.Email)
			// continue
			c.Next()
			return
		}

		// 5) else abort
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token claims"})
	}
}
