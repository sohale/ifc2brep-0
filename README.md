# ifc2brep-0
PoC for an IFC to BREP converter for BIM  in C++ (3D, BIM, cli)

### Features (provisional):
* Is a CLI application `ifc2brep-0`, written in C++.
* It uses IFC [SDK](https://www.opendesign.com/products/ifc-sdk).
* The BREP files are in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts).
* It converts "cylinders", "circular arcs", etc [TBC]
* IFC is partially implemented in the PoC: "cylinders" and "circular arcs", enough to convert certain sample files.

### Sponsor
Sponsored by **Novorender** "*The World`s Most Powerful Digital Twin & BIM Platform*"
* Novorender: [novorender.com](https://novorender.com/) ([on linkedin](https://www.linkedin.com/company/novorender/about/)) `013cbab0ccd3c7fd21`
* Sample files are kindly provided by RISA Norway: [risa.no](https://risa.no)

### Usage
* IFC viewer: [Open IFC Viewer](https://openifcviewer.com/)
#### Output format
The BREP files will be in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts). 
* IFC `id`s are used as filenames, e.g. `0f7I2_mxX3JOk$Z$4oj$LI.json`

### Technical Details
* Uses ODA's IFC [SDK](https://www.opendesign.com/products/ifc-sdk)


## Reproduction:
i.e. running this

Everything is automated and version controlled, but you ned to have your secrets file

### Sectets (license/activation)
```
secrets/
├── OdActivationInfo
└── secrets.txt
```

Curent contents: of `secrets/secrets.txt`
```bash
# ODA IFC SDK

ODA_EMAIL="...@..."
ODA_PASSWORD="...given to you initially during registration "
IFC_ACTIVATION_CODE="a 245-letter code, from the activation process (involves manual & JIRA)"
ODA_SERIALNUMBER="a 42-letter thing that comes orm your Wine64 dir instance"
```
you will need aa 44 letter "ODA hardware code" in the process of activation, but you dont need that here.

The "OdActivationInfo" file should be placed in `secrets/OdActivationInfo`
The 143-byte file, created by a second process


1. registering
   * involves your initiation
2. receive email with uname pass
   * involves receiveing from their servers
   * make note of them
3. create a jira ticket
   * involvs inputs from outside (process: people & servers)
      * involved "owrking days": paused on weekends
   * involves your initiation
4. wait for their code gievn to you
5. use that in the automated process
   * involvs outside servers
   * involves your continuation (follow-up "tick" step): manual steps (most complex part)
      * There is a chance that it may involve struggle with Wine, etc. But I sovled it, so hopefully my mehtod works without much difficulty for you.
6. Note that it expires.
   * The ODA team is responsive & proactive
   expired in a month since (since which step?)
7. Outcome: a file you put in `secrets/OdActivationInfo`

#### Initiation points
It is not a one-click solution as I hoped, you need to do things manually & initiate some processes, etc, run scripts, etc at a few points:

1. clone the repo
2. set the volume folder(s) in the scripts ( I use a separate foldeR)
2. run the install scripts (including docker build, also: including: docker insallation, and if necessary docker temp fil to be moved)
   * scripts/helpers/helper-change-docker-temp.bash
   * more details are documented in scripts/init-setup.bash but may need reverse engineering, and, it is not a script, it is a documentation file pretending to be a bash script
       * involves x-windows setup (if like me you use remote)
       * but I automated it
       * but have not reproduced. So the information & knowhow is there, and auomated in a reasonable amount, but I have not proved it to be reproducible with one click, streamlined, verified, etc. This will happen over time by incremental iterations.
3. Initiate the whole activation process
   * is rate liminting
   * can expire
   * required follow-up
4. setup the LSP too (on vscode) -- so you need to set up vscode too (you an use it remotely, I do it , this readme is based on such a setup that I made it work)
5. run the Script(s) that create the .env files
6. run the scripts that run the docker thing (needs to have has its docker built. ..., and hence, u-dependency: to docker instalaltion and temp & volume setup (some `mount` step for my d.o. VPS setup )
        * you will have two solutions work at the same time, sol2, sol3, (also LSP can be seen as a third one). You will need to switch between them interactively
7. The compile3 (sol3)
8. The run script (Sol2) to test your execution
9. You will need to switch between them interactively.
   * There you are. Where you (always) wanted to be.

* Possible extention: (for future)
  * automate the compile-run cycle
  * improvemens on the interactive
  * create terraform etc (but will require provider, so it cannot be multi-cloud uni-cloud ./ cross-cloud out of the box)
  * Making CI s for it
  * direct debugging (for vscode, etc)
  * Put the wine into
  * combine sol2 & sol3 (may not be a good idea since heavily involes microsoft visual studio installation)
  * The no-do s: No CMake ⛔️
  * Use / set up conan.io
  * some refactoring of scripts (also into a/the framework)
  * needs a big cleanup (the whole thing. Hence, the `.version.txt` "cleaning (clean-code-ing)" system with its tag system)
  * automate the orgL aspects


Steps
```bash
cd ......ifc2brep-0
./scripts/bash-stub.bash   # creates ./env_common.env

# via ./env_common.env
./scripts/wine_init_sol3.bash  # runs (and builds) the docker
〉 ./scripts/inside_msvc-wine/compile3.bash

# only once? scripts/wine_init.bash
# carefule: re-creates the wine env (sol2), so shoul dbe run once, beause it can be slow
scripts/wine_init.bash
# Also goes intide the cmd.exe. May run winecfg, etc
# todo: also: mark the resulting.env file as read-only?


# via: env2_sol2.env
./scripts/wine_run_built_exe_sol2.bash
```

## Where the core code starts
Plunge point:
Core part to satart looking at (bypass the big overhead)
* Where to look first: [`./src/first_ifcapp.cpp`](src/first_ifcapp.cpp)

<!-- open these side by side:
examples/novo-samples/SP-00-VA.ifc
src/first_ifcapp.cpp
README.md
-->


### todo items
* todo items for toolchain
   * docker build logs to be `--` plain
   * docker buildx usage (done), and installation documentation )
   * automate fixing of vscode version guards
