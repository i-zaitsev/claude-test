package main

import (
	"context"
	"fmt"
	"os"

	"claude-test/internal/cli"
)

func main() {
	app := cli.NewCLI()

	if err := app.Parse(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	if err := app.Run(context.Background()); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}
