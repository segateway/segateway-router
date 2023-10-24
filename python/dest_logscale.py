#! /usr/bin/env python3
import os
import jinja2
from furl import furl
from yaml import safe_load, dump
from dotenv import load_dotenv

load_dotenv()


config_path = os.environ.get("SEGWAY_CONFIG_PATH", "")
config_file = os.path.join(config_path, "config.yaml")

SEGWAY_DEST_otlp_HOST = os.environ.get("SEGWAY_DEST_otlp_HOST", "")
SEGWAY_DEST_otlp_PORT = os.environ.get("SEGWAY_DEST_otlp_PORT", "")
SEGWAY_DEST_otlp_PROTOCOL = os.environ.get("SEGWAY_DEST_otlp_PROTOCOL", "")
SEGWAY_DEST_otlp_TOKEN = os.environ.get("SEGWAY_DEST_otlp_TOKEN", "")
SEGWAY_DEST_otlp_INSTANCE_NAME = os.environ.get(
    "SEGWAY_DEST_otlp_INSTANCE_NAME", "unknown_instance"
)
if SEGWAY_DEST_otlp_PORT == "":
    SEGWAY_DEST_otlp_PORT = None


def main():
    otlpURL = furl().set(
        host=SEGWAY_DEST_otlp_HOST,
        scheme=SEGWAY_DEST_otlp_PROTOCOL,
        port=SEGWAY_DEST_otlp_PORT,
    )
    url = otlpURL.origin

    plugin_path = os.path.dirname(os.path.abspath(__file__))

    templateLoader = jinja2.FileSystemLoader(searchpath=plugin_path)
    templateEnv = jinja2.Environment(loader=templateLoader)
    tm = templateEnv.get_template("dest_otlp.jinja")

    with open(config_file, "r") as file:
        config = safe_load(file)

    for logPath in config["logPaths"]:
        if "flow-control" not in logPath["flags"]:
            logPath["flags"].append("flow-control")
        if "tags" not in logPath:
            logPath["tags"] = []

    conf = tm.render(
        config=config,
        instance=SEGWAY_DEST_otlp_INSTANCE_NAME,
        url=url,
        token=SEGWAY_DEST_otlp_TOKEN,
    )
    print(conf)


if __name__ == "__main__":
    main()
