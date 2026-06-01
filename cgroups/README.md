# Study Linux concepts using alpine image


## CLI commands for stres-ng
```text
# Run CPU stressors for 60 seconds
# --cpu N => N workers performing CPU-intensive math and crypto operations
stress-ng --cpu 8 --timeout 60s


# Run memory(RAM) stressors for 2 minute
# --vm N => N workers performing random memory read/write operations
stress-ng --vm 3 --timeout 2m


# Full stress test - CPU, memory for 10 minutes
stress-ng \
    --cpu $(nproc) \
    --vm 1 \
    --vm-bytes 95% \
    --timeout 600s


# Full system stress test - CPU, memory, disk, and I/O
# Run for 10 minutes to identify thermal and stability issues
stress-ng \
    --cpu $(nproc) \
    --vm 1 \
    --vm-bytes 95% \
    --hdd 2 \
    --io 4 \
    --timeout 600s \
    --metrics-brief

```

## References
- [Stree-ng Github](https://github.com/ColinIanKing/stress-ng)
- [Stree-ng usage](https://oneuptime.com/blog/post/2026-03-02-run-stress-ng-system-stress-testing-ubuntu/view#basic-concepts)