# Kopia settings

Using KopiaUI is easy to manage kopia settings.

## Cache setting

[Reference](https://kopia.io/docs/advanced/caching/#cache-directory-location)


### Cache directory

Engaging another directory for caching is critical, defaults to `%LocalAppData%\kopia\{unique-id}` on Windows, which  
takes much place. `KOPIA_CACHE_DIRECTORY` environment variable is recommended to be set to non-system disks.

### Cache size

In addition, cache size should be limited as well, which are specified in `repository.config` file, like this:

```
{
  "storage": {
    "type": "filesystem",
    "config": {
      "path": "F:\\Kopia\\data",
      "dirShards": null
    }
  },
  "caching": {
    "cacheDirectory": "F:\\Kopia\\cache",
    "maxCacheSize": 2097152000,
    "maxMetadataCacheSize": 2097152000,
    "maxListCacheDuration": 30
  },
  "hostname": "bad-pc",
  "username": "ddsr",
  "description": "Local Repository",
  "enableActions": false,
  "formatBlobCacheDuration": 900000000000
}
```

The default values for `maxCacheSize` and `maxMetadataCacheSize` are 5GB and 5GB respectively, adjusted to 2GB.

## Log setting

[Reference](https://kopia.io/docs/advanced/logging/#log-file-location)

The log files are stored in `%LocalAppData%\kopia\` on Windows, also located in system disks. Therefore, moving logs to 
another directory is recommended.

These variables are set as bellow:

* KOPIA_LOG_DIR
* KOPIA_LOG_DIR_MAX_FILES
* KOPIA_LOG_DIR_MAX_AGE
* KOPIA_CONTENT_LOG_DIR_MAX_FILES
* KOPIA_CONTENT_LOG_DIR_MAX_AGE

## Snapshot setting

I remove all snapshot retention policy but Latest Snapshots policy. Keeping three latest snapshots, the values for other
policy(Hourly, Daily, Monthly...) are set to 0.