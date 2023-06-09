import { createWriteStream } from "fs";
import path from "path";

import mime from "mime-types";

import { log } from "../log";
import { temporaryDirectory } from "../consts";

import { url } from ".";

export const viewImageUrl = (imageId: string, query: Record<string, string>) =>
	url(`/v1/images/${imageId}/view?${new URLSearchParams(query).toString()}`);

export const download = async (fileGroup: string, imageId: string) => {
	const response = await fetch(viewImageUrl(imageId, { format: "jpeg" }), {
		redirect: "follow"
	});

	const extension = mime.extension(response.headers.get("content-type") || "");
	const output = path.resolve(temporaryDirectory, fileGroup, `${imageId}.${extension}`);

	const buffer = Buffer.from(await response.arrayBuffer());
	createWriteStream(output).write(buffer);

	log.info({ fileGroup }, `Downloaded ${imageId}.`);
};
