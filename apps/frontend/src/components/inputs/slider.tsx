"use client";

import * as React from "react";
import * as SliderPrimitive from "@radix-ui/react-slider";
import { twMerge } from "tailwind-merge";

export const Slider = React.forwardRef<
	React.ElementRef<typeof SliderPrimitive.Root>,
	React.ComponentPropsWithoutRef<typeof SliderPrimitive.Root>
>(({ className, ...props }, reference) => (
	<SliderPrimitive.Root
		ref={reference}
		className={twMerge(
			"relative flex w-full touch-none select-none items-center",
			className
		)}
		{...props}
	>
		<SliderPrimitive.Track className="relative h-2 w-full grow overflow-hidden rounded-full bg-black-50 shadow-brand-1">
			<SliderPrimitive.Range className="absolute h-full bg-brand-gradient" />
		</SliderPrimitive.Track>
		{(props.value || props.defaultValue)?.map((_, index) => (
			<SliderPrimitive.Thumb
				className="block h-5 w-5 rounded-full border-2 border-none bg-brand-gradient shadow-brand-1 transition-colors focus:outline-none focus:ring-2 focus:ring-theme-1 focus:ring-offset-2 focus:ring-offset-white-20 disabled:pointer-events-none disabled:bg-black-40 disabled:opacity-50 dark:ring-offset-black-50"
				key={index}
			/>
		))}
	</SliderPrimitive.Root>
));

Slider.displayName = SliderPrimitive.Root.displayName;
