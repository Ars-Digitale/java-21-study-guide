# Java 21 Certification Course (Eclipse + YouTube)


Welcome! This repo contains notes (Markdown & PDF), code samples, and exercises for a Java 21 course recorded with Eclipse.


## What you’ll find
- **`docs/`** – lesson notes in Markdown (rendered nicely on GitHub)
- **`slides/`** – exported PDFs of the lesson notes/slides
- **`code/`** – Java code per module (Eclipse-friendly)
- **`exercises/` & `solutions/`** – practice tasks and answers
- **`assets/`** – images and other assets used in docs
- **`scripts/`** – helper scripts (e.g., Markdown → PDF)


## Requirements
- **JDK 21 (LTS)**
- **Eclipse IDE** (or any IDE)
- **Git** (to clone/pull updates)
- Optional: **Pandoc** (to export Markdown → PDF)


## Using the repository
1. **Read lesson notes online:** open files in `docs/` on GitHub.
2. **Download slides:** PDFs live in `slides/`.
3. **Run code:** import the folder under `code/` into Eclipse:
- *Eclipse → File → New → Java Project* → Name it (e.g., `module-01-hello-world`).
- Copy the contents of `code/module-01-hello-world/src` into your project’s `src` folder (or use *File → Import → General → File System* to import the folder).
4. **Export Markdown to PDF:**
- Linux/macOS: run `scripts/md2pdf.sh`.
- Windows: run `scripts/md2pdf.bat`.


## Structure by module
- **Module 01 – Intro & Hello World**
- Notes: `docs/module-01-intro.md`
- Code: `code/module-01-hello-world/`
- Slides (PDF): `slides/module-01-intro.pdf` (generated)
- Exercises: `exercises/module-01/`
## License
This project is licensed under the **MIT License** (see `LICENSE`).


## Contributing
Contributions and fixes are welcome! See `CONTRIBUTING.md`.


