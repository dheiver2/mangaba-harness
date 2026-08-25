// Mangaba brand mark (mangaba fruit), extracted from the official Mangaba
// artwork. Native bbox 291..393 x 193..303; rendered 24px wide by default,
// hero usage scales to 34. Brand colors are intrinsic — the mark does not ride
// currentColor, so the fruit keeps its gradient in both themes.

import type { IconProps } from './icons/props.ts'

/**
 * Render the Mangaba mark.
 * @param props.size - width in px (default 24; height keeps the artwork ratio).
 * @param props.className - extra class for layout placement.
 * @returns the mark svg (aria-hidden; pair with the wordmark for accessibility).
 */
export function MangabaLogo({ size = 24, className }: IconProps) {
  return (
    <svg
      width={size}
      height={(size * 110) / 102}
      className={className}
      viewBox="291 193 102 110"
      fill="none"
      aria-hidden="true"
    >
      <path d="M348.547 214.683C348.528 214.964 348.44 216.133 348.365 216.421C347.605 218.862 351.313 219.319 352.154 217.814C352.54 217.124 352.751 214.796 353.066 213.869L353.188 213.881C355.348 214.088 357.665 213.753 359.863 214.009C373.709 215.621 383.269 224.376 387.03 237.639C390.597 250.457 388.079 263.834 381.627 275.295C376.072 285.16 366.987 295.131 355.742 298.262C349.263 300.077 342.326 299.203 336.498 295.841C335.757 295.422 335.024 294.976 334.344 294.462C333.905 294.211 332.947 293.48 332.55 293.151C322.283 284.595 316.652 269.91 315.444 256.893C314.539 247.137 316.865 236.809 323.207 229.167C328.661 222.594 335.932 218.667 343.931 215.936C344.672 215.683 347.842 214.752 348.547 214.683Z" fill="url(#paint1_linearMgbMark)"/>
      <g opacity="0.56" filter="url(#filter0_fMgbMark)">
        <path d="M378.278 248.196C380.94 257.767 379.061 267.755 374.243 276.312C370.096 283.678 363.312 291.123 354.916 293.46C350.078 294.815 344.899 294.163 340.547 291.653C339.994 291.34 339.447 291.007 338.939 290.623C339.144 290.583 339.895 290.643 340.14 290.665C341.313 290.77 342.348 290.697 343.467 290.298C348.999 288.328 349.173 282.938 350.932 278.301C351.988 275.56 353.629 273.213 355.788 271.248C358.496 268.785 361.585 267.548 364.918 266.206C367.524 265.158 369.769 263.411 371.564 261.246C373.309 259.141 374.003 256.815 374.967 254.332C375.619 252.602 376.427 250.934 377.382 249.35C377.609 248.981 377.923 248.411 378.278 248.196Z" fill="url(#paint2_linearMgbMark)"/>
      </g>
      <path d="M293.273 222.814L293.167 222.748C293.201 222.521 293.734 222.243 293.96 222.091C300.231 217.887 302.972 210.233 308.26 204.934C314.358 198.823 322.909 195.036 331.609 196.215C339.507 197.285 344.596 203.519 349.843 208.57C350.786 206.42 353.189 198.296 355.213 197.487C355.899 197.213 356.817 197.502 357.454 197.814C358.279 198.218 358.894 198.833 359.336 199.634C359.059 200.408 357.913 201.792 357.459 202.61C355.877 205.465 354.687 208.309 353.746 211.433C353.54 212.115 353.165 213.19 353.066 213.869C352.75 214.796 352.539 217.124 352.154 217.815C351.313 219.319 347.524 219.477 348.375 216.076C348.575 215.273 348.375 216.076 348.547 214.684L349.377 210.65C347.439 209.56 345.164 209.427 343.035 210.006C339.584 210.946 337.524 213.748 335.239 216.245C334.285 217.279 333.282 218.269 332.236 219.211C321.373 228.945 306.887 230.399 294.098 223.355C293.767 223.172 293.566 223.055 293.273 222.814Z" fill="url(#paint3_linearMgbMark)"/>
      <path d="M293.273 222.814L293.167 222.748C293.201 222.521 293.734 222.243 293.96 222.091C300.231 217.887 302.972 210.233 308.26 204.934C314.358 198.823 322.909 195.036 331.609 196.215C339.507 197.285 343.55 202.986 348.797 208.037C348.237 208.09 344.703 206.609 343.702 206.36C341.005 205.691 338.308 205.197 335.504 205.266C326.616 205.638 320.13 209.489 313.382 214.903C310.806 216.969 307.655 219.257 304.633 220.595C302.051 221.737 299.657 222.263 296.866 222.561C296.173 222.635 293.716 222.602 293.273 222.814Z" fill="url(#paint4_linearMgbMark)"/>
      <g opacity="0.57" filter="url(#filter1_fMgbMark)">
        <ellipse cx="367.648" cy="245.386" rx="13.4507" ry="18.4696" fill="#E94A12"/>
      </g>
      <g opacity="0.43" filter="url(#filter2_fMgbMark)">
        <path d="M336.129 254.42C336.129 264.62 341.751 276.503 334.322 276.503C326.893 276.503 318.864 261.207 318.864 251.007C318.864 240.807 333.92 225.712 341.348 225.712C348.777 225.712 336.129 244.219 336.129 254.42Z" fill="#FFFAE8"/>
      </g>
      <defs>
        <filter id="filter0_fMgbMark" x="331.984" y="241.241" width="54.463" height="59.8661" filterUnits="userSpaceOnUse" colorInterpolationFilters="sRGB">
          <feFlood floodOpacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="3.47756" result="effect1_foregroundBlurMgbMark"/>
        </filter>
        <filter id="filter1_fMgbMark" x="336.571" y="209.29" width="62.1542" height="72.192" filterUnits="userSpaceOnUse" colorInterpolationFilters="sRGB">
          <feFlood floodOpacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="8.8132" result="effect1_foregroundBlurMgbMark"/>
        </filter>
        <filter id="filter2_fMgbMark" x="312.838" y="219.686" width="36.8749" height="62.8434" filterUnits="userSpaceOnUse" colorInterpolationFilters="sRGB">
          <feFlood floodOpacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="3.01304" result="effect1_foregroundBlurMgbMark"/>
        </filter>
        <linearGradient id="paint0_linearMgbMark" x1="913.173" y1="479.367" x2="1271.29" y2="580.089" gradientUnits="userSpaceOnUse">
          <stop stopColor="#FFFCF0"/>
          <stop offset="1" stopColor="#FFDFCC"/>
        </linearGradient>
        <linearGradient id="paint1_linearMgbMark" x1="301.197" y1="291.56" x2="389.056" y2="316.358" gradientUnits="userSpaceOnUse">
          <stop offset="0.19869" stopColor="#FFD83D"/>
          <stop offset="0.623365" stopColor="#FF7A1A"/>
          <stop offset="1" stopColor="#7BBF26"/>
        </linearGradient>
        <linearGradient id="paint2_linearMgbMark" x1="340.872" y1="242.588" x2="369.651" y2="287.107" gradientUnits="userSpaceOnUse">
          <stop stopColor="#FFE498" stopOpacity="0"/>
          <stop offset="0.978887" stopColor="#FFE498"/>
        </linearGradient>
        <linearGradient id="paint3_linearMgbMark" x1="334.723" y1="205.436" x2="302.803" y2="263.856" gradientUnits="userSpaceOnUse">
          <stop stopColor="#689924"/>
          <stop offset="1" stopColor="#23330C"/>
        </linearGradient>
        <linearGradient id="paint4_linearMgbMark" x1="336.53" y1="199.413" x2="295.777" y2="222.901" gradientUnits="userSpaceOnUse">
          <stop stopColor="#689924"/>
          <stop offset="1" stopColor="#39410B"/>
        </linearGradient>
      </defs>
    </svg>
  )
}
