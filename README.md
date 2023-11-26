# Advanced High Performance Computing Cluster Practice
## Brief Introduction to Intel® VTune™ Profilers

Here are some frequently-used code snippets.

## Set up envrionment variables

```bash
# If module is available
module load vtune
# Generally, $PATH_TO_VTUNE would be `/opt/intel/oneapi/latest/vtune` or `$HOME/intel/oneapi/vtune/latest`
. $PATH_TO_VTUNE/setvars.sh
```

## Intel® VTune™ Amplifier’s Application Performance Snapshot

### Generate results

APS would first create a directory containing results. By default, the directory would be named after date and time. It could be specified through `--result-dir=$RESULT_DIR` optionally.

```bash
# w/o MPI
aps $APPLICATION $APPLICATION_PARAMETERS
# w/ MPI
$MPI_LAUNCHER $MPI_PARAMETERS aps $APPLICATION $APPLICATION_PARAMETERS
# w/ Intel MPI, alternatively
$IMPI_LAUNCHER $IMPI_PARAMETERS -aps $APPLICATION $APPLICATION_PARAMETERS
```

### Convert result to report

Then, we need obtain the analysis report (in HTML) based on the result data.

```bash
aps-report $RESULT_DIR
```

To open the HTML report, we could start web brower like FireFox via X11 forwarding. Alternatively, in the light of the latency, we could also start a simple web server at the directory temporally. For instance, this could be realized with Python's inbuilt `http.server`:

```bash
# Make sure you `cd` to the directory containing the report
python3 -m http.server
```

And now, we could open browser locally and enter `$IP_OR_HOSTNAME:8000` to the address bar. Don't forget to close the server with <kbd>Ctrl</kbd> + <kbd>C</kbd>.

## Intel® VTune™ Amplifier

Note: in some old documents, `vtune` & `vtune-gui` were `amplxe` & `amplxe0-gui`, respectively.

### Collect data

Common available collect options:
- Hotspots (`hotspots`)
- Memory Consumption (`memory-consumption`)
- Microarchitecture Exploration (`uarch-exploration`)
- Memory Access (`memory-access`)
- Threading (`threading`)
- HPC Performance Characterization (`hpc-performance`)
- I/O (`io`)

```bash
# w/o MPI
vtune -collect $COLLECT_OPTION -r $RESULT_DIR $APPLICATION $APPLICATION_PARAMETERS
# w/ MPI
$MPI_LAUNCHER $MPI_PARAMETERS vtune -collect $COLLECT_OPTION -r $RESULT_DIR $APPLICATION $APPLICATION_PARAMETERS
# w/ Intel MPI, sample specific ranks only (This is of help since we may need sample the lowest ranks)
$IMPI_LAUNCHER $IMPI_PARAMETERS -gtool "vtune -collectt $COLLECT_OPTION -r $RESULT_DIR: $RANKS" $APPLICATION $APPLICATION_PARAMETERS
```

### View the report

We could open the GUI directly on the remote machine with `vtune-gui $RESULT_DIR` via X11 forwarding. Nevertheless, due to the almost unacceptable latency, we might have installed VTune™ locally, downloading the result directory and investigating the report in local.

There is a more feasible solution. We could run the `vtune-backend` on the remote machine, and it would work as a web server.

```bash
vtune-backend --allow-remote-access --data-directory $PARENT_DIR_TO_RESULT_DIRS
```

Subsequently, we could open browser in local and enter the IP address (or hostname) and the port to the address bar. For the first time, you may need set up a password.
