# MyLastAuthentication

## Outline  

1. Problem Description  
2. Solution Specification  
3. Design  
4. Implementation  
5. Experiments  
6. Conclusions  

## Problem Description  

- Processing log files from Linux systems (`auth.log`).  
- Identifying relevant data based on user and time range.  
- Importance: simplifying log analysis for administrators.  
- Possible solutions: using standard tools (e.g., `awk`, `grep`) vs. a custom script.  
- Performance measures: filtering efficiency and ease of use.  

## Specification  

**Objectives:** Develop a simple script for log analysis.  
**Features:**  
- Filtering based on user and time range.  
- Limiting the number of displayed lines.  
**Requirements:**  
- Operating System: Linux.  
- Necessary tools: Bash, `awk`, `less`, `cat`, `grep`.  
- Constraints: log files are decompressed using the `less` command.  

## Design  

**Modular architecture:**  
- Parsing user arguments.  
- Reading and decompressing log files.  
- Filtering logs using `awk`.  
**Algorithm and mechanism choices:**  
- `less` and `cat` for file reading.  
- `awk` for extracting relevant data.  
- Comparison with existing tools: the script provides added flexibility.  

## Implementation  

**Main component:** Bash script.  
**Use of standard Linux libraries:**  
- `cat` and `less` for reading files.  
- `awk` for processing log lines.  
**Implementation details:**  
- Parsing options using Bash.  
- Filtering based on user and time.  
- Limiting results using `head`.  

## Experiments  

**Testing platform:**  
- Linux system (Ubuntu 22.04).  
- Machine with i7 10750H processor, 32GB RAM.  
**Test data:**  
- Log files up to 100 MB.  
- Compressed and uncompressed logs.  
**Performance metrics:**  
- Processing time for different file sizes.  
- Filtering accuracy (manual validation).  

## Conclusions  

- The script provides a flexible solution for log analysis.  
- Ease of use through specific options (e.g., `-n`, `-p`, `-s`, `-t`, `-h`).  
- Potential for extension to other log types.  
- Good performance even for large files.  
- Limitations: dependence on Linux log formats.  
