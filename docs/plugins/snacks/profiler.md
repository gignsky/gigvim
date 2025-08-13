# Snacks.nvim Profiler

The profiler module provides comprehensive performance profiling tools for Neovim, helping identify bottlenecks and optimize your configuration.

## Features

- **Startup Profiling**: Measure plugin load times and startup performance
- **Function Profiling**: Profile specific functions and operations
- **Memory Tracking**: Monitor memory usage and detect leaks
- **Real-time Monitoring**: Live performance metrics during editing
- **Report Generation**: Detailed profiling reports and visualizations

## Configuration

The profiler module is enabled by default:

```lua
require('snacks').setup({
  profiler = { enabled = true }
})
```

### Advanced Configuration

```lua
profiler = {
  enabled = true,
  startup = true,        -- Profile startup
  runtime = true,        -- Profile runtime operations
  memory = true,         -- Track memory usage
  output = "profile.log" -- Output file for reports
}
```

## Usage

### Basic Profiling Commands

- `:lua Snacks.profiler.start()` - Start profiling session
- `:lua Snacks.profiler.stop()` - Stop profiling and generate report
- `:lua Snacks.profiler.startup()` - Profile startup performance
- `:lua Snacks.profiler.report()` - Show profiling report

### Startup Profiling

Profile Neovim startup to identify slow-loading plugins:

```lua
-- Enable startup profiling
Snacks.profiler.startup()

-- View startup report
Snacks.profiler.startup_report()
```

### Function Profiling

Profile specific functions or code blocks:

```lua
-- Profile a function
Snacks.profiler.profile(function()
  -- Your code here
  vim.cmd('edit large_file.txt')
end)

-- Profile with custom name
Snacks.profiler.profile("file_loading", function()
  vim.cmd('edit large_file.txt')
end)
```

### Memory Profiling

Monitor memory usage patterns:

```lua
-- Start memory tracking
Snacks.profiler.memory_start()

-- Your operations...

-- Get memory report
local report = Snacks.profiler.memory_report()
print(vim.inspect(report))
```

## Profiling Reports

### Startup Report
Shows plugin load times and initialization performance:
- Plugin load order
- Time spent per plugin
- Total startup time
- Optimization suggestions

### Runtime Report
Tracks performance during normal operation:
- Function call frequency
- Execution times
- Memory allocations
- Performance hotspots

### Memory Report
Monitors memory usage patterns:
- Memory allocation tracking
- Garbage collection statistics
- Memory leak detection
- Memory optimization tips

## Performance Analysis

### Identifying Bottlenecks
1. Run startup profiling: `:lua Snacks.profiler.startup()`
2. Identify slow plugins or configurations
3. Profile specific operations that feel slow
4. Use memory profiling for memory-intensive operations

### Optimization Strategies
- Lazy-load plugins that aren't immediately needed
- Optimize large configuration files
- Reduce autocommand overhead
- Monitor memory usage patterns

## Testing

To verify the profiler module:

1. Run `:lua print(require('snacks').profiler)` - should return a table
2. Start a profiling session: `:lua Snacks.profiler.start()`
3. Perform some operations, then stop: `:lua Snacks.profiler.stop()`
4. View the report: `:lua Snacks.profiler.report()`
5. Check `:checkhealth snacks` for profiler status

## Integration

### CI/CD Integration
Use profiling in automated testing:
```lua
-- Automated performance testing
local function test_performance()
  Snacks.profiler.start()
  -- Run test operations
  local report = Snacks.profiler.stop()
  assert(report.total_time < 100) -- Ensure performance targets
end
```

### Development Workflow
Integrate profiling into your development process:
1. Profile before major changes
2. Compare performance after modifications
3. Set performance benchmarks
4. Monitor regression in CI

## Benefits

- **Performance Optimization**: Identify and fix performance bottlenecks
- **Startup Speed**: Optimize Neovim startup time
- **Memory Efficiency**: Detect and prevent memory leaks
- **Development Insights**: Understand code execution patterns
- **Continuous Monitoring**: Track performance over time