import { Googleplay, Apple, Microsoft, Meta } from "@icons-pack/react-simple-icons";

import { MobileButton } from "~/components/mobile-button";
import { Footer } from "~/components/layout/footer";

import { SectionCallToAction } from "./section-call-to-action";
import { SectionCarousel } from "./section-carousel";
import { SectionAvatarProfiles } from "./section-avatar-profiles";
import { SectionTestimonial } from "./section-testimonial";
import { SnapSection } from "./snap-section";
import { LandingButton } from "./landing-button";

export default function RootIndexPage() {
	return (
		<div className="h-screen snap-y snap-mandatory overflow-x-hidden scroll-smooth bg-black text-white md:snap-none">
			<SectionCallToAction />
			<SectionAvatarProfiles
				values={[
					"When you can choose how you look, it's personality that makes the difference.",
					"VR lets you be more real.",
					"Vibe check in VR before sending IRL pics or video calling."
				]}
			/>
			<SectionCarousel
				values={[
					["b9326c15-c996-488f-8d68-d7ea4cb8649b", "Feed some ducks"],
					["738f3d22-6f38-4059-9dd3-7fdd672acccd", "Swim with sharks"],
					["be840a83-86f9-4ba2-87ae-3cd93f73f099", "Chill in a cafe"],
					["107737a5-d694-43db-a082-0d71bdfc4105", "Observe a black hole"],
					["30023b24-f08a-43d4-918a-aa8940cefb24", "Touch grass"],
					["09402677-a01e-4f6b-9171-f8c533ec774f", "Paint together"],
					["7e736467-63c4-4ff4-9989-54546b24cc6f", "Play some pool"]
				]}
			/>
			<SectionTestimonial
				brands={[
					"29a2f1bc-0b3e-469a-aa11-0de69b75b629",
					"257a7f46-a6c1-4bee-9a3e-5dbdfe9d2a66",
					"18e4a7ad-625a-42f6-b581-d14386ced012",
					"db2eb424-e837-4d64-85e0-e49409ae33a6",
					"54ffe640-1c54-4d8f-a754-4c7b7ca82456",
					"b779aa38-8592-48cd-8f9b-88228c5abc21",
					"1a03f086-7a3a-41f6-a7cf-035a83c10fa4",
					"fd92ab0f-d264-4a69-813f-bea13def2c46"
				]}
				images={[
					"a68e9441-8430-4a33-a067-04313d4d260c",
					"5e0d4116-2e60-4ae9-b865-3ce7d17c68ec",
					"01db5707-2aac-45cd-a80c-223c6e1b93f2",
					"b8ea7c5b-5110-46b7-8635-38728e8a77aa",
					"eea60bde-de1a-4f43-9f02-a218fddf2a73",
					"ad5cba2d-03ff-43eb-9cf3-e6986bb0be54",
					"40122187-d831-4131-ab8e-ee0f5544ce73",
					"17b87f45-0ef8-4dfa-80c4-c23450f09b30",
					"28eaf327-e2bd-4fd2-a7f9-4dd6be153bfc",
					"5bbf00fc-2c97-49b2-9f16-9d3c1a180ae8",
					"f3b27da8-4f36-4c7f-bd65-094421d28f22",
					"c0d8ad7f-a6df-4de8-a429-a8fa729bf447",
					"9f2de017-6b5a-4ca9-b858-95057889fd64",
					"b8b087b9-3ab3-4a05-b01a-166b502789f5"
				]}
			/>
			<SnapSection className="flex flex-col bg-brand-gradient">
				<div className="flex h-full grow items-center justify-center p-16 pb-0 md:pb-16">
					<div className="flex flex-col items-center gap-8 md:gap-16">
						<h1 className="font-montserrat text-4xl font-extrabold sm:text-7xl md:text-8xl">
							Get Flirtual
						</h1>
						<LandingButton href="/register" kind="secondary-cta">
							Sign up
						</LandingButton>
						<div className="grid grid-cols-1 gap-4 gap-y-2 md:grid-cols-2">
							<MobileButton
								href="https://play.google.com/store/apps/details?id=zone.homie.flirtual.pwa&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"
								Icon={Googleplay}
								label="Play Store"
							/>
							<MobileButton href="/ios" Icon={Apple} label="iPhone/iPad" />
							<MobileButton
								href="https://apps.microsoft.com/store/detail/flirtual/9NWCSDGB6CS3?cid=storebadge&ocid=badge&rtc=1"
								Icon={Microsoft}
								label="Windows"
							/>
							<MobileButton
								href="https://sidequestvr.com/app/9195"
								Icon={Meta}
								label="Side Quest"
							/>
						</div>
					</div>
				</div>
				<Footer />
			</SnapSection>
		</div>
	);
}
