import "server-only";

export const environment = (process.env.VERCEL_ENV || process.env.NODE_ENV) as string;
export const region = process.env.VERCEL_REGION as string;

export const gitOrganization = process.env.VERCEL_GIT_REPO_OWNER as string;
export const gitRepository = process.env.VERCEL_GIT_REPO_SLUG as string;
export const gitCommitSha = process.env.VERCEL_GIT_COMMIT_SHA as string;
export const gitCommitRef = process.env.VERCEL_GIT_COMMIT_REF as string;

export const gitCommitUrl = gitCommitSha
	? `https://github.com/${gitOrganization}/${gitRepository}/commit/${gitCommitSha}`
	: null;