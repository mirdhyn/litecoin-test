package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	cmd := exec.Command("git", "log")
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	file, err := os.ReadFile(os.Args[1])
	if err != nil {
		panic(err)
	}

	for _, line := range strings.Split(string(stdout), "\n") {
		if strings.Contains(line, "commit") {
			commit := strings.Split(line, " ")[1]
			fmt.Println(strings.Replace(string(file), "latest", commit, 1))
			break
		}
	}

}
