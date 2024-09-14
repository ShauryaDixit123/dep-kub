package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()
	r.GET("/ping", func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{"message": "pong!"})
	})
	if er := r.Run(":15432"); er != nil {
		panic("Error occured in startup")
	}
}
