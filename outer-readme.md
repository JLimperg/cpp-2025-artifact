# Artifact for "Tactic Script Optimisation for Aesop"

This is the artifact for the paper "Tactic Script Optimisation for Aesop", submitted to CPP 2025.
The artifact contains two components:

- A tar archive, `artifact.tar.xz`.
  This contains source files and build instructions for Aesop and for the evaluation.

  To work with the archive, simply unpack it and follow the instructions in the enclosed README.

- A Docker image, `image.tar.xz`.
  This contains the same source files as the archive, but also the correct versions of Lean and of all dependencies.
  Hence, the image is fully self-contained and should allow the paper's results to be reproduced even if Lean's tooling changes.

  To work with the image, first load it as a Docker image:

      docker load -i image.tar.xz

  The uncompressed archive takes around 1.6G of disk space.
  Then run a Docker container:

      docker run --rm -it artifact:latest

  The above command starts a `bash` shell within the container.
  See the README within the container for further instructions.
  Note the `--rm` argument, which will cause the container to be deleted once you exit it.
