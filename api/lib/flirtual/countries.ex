defmodule Flirtual.Countries do
  # https://en.wikipedia.org/wiki/ISO_3166-1
  # https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

  @countries [
    %{iso_3166_1: :af, name: "Afghanistan"},
    %{iso_3166_1: :ax, name: "Aland Islands"},
    %{iso_3166_1: :al, name: "Albania"},
    %{iso_3166_1: :dz, name: "Algeria"},
    %{iso_3166_1: :as, name: "American Samoa"},
    %{iso_3166_1: :ad, name: "Andorra"},
    %{iso_3166_1: :ao, name: "Angola"},
    %{iso_3166_1: :ai, name: "Anguilla"},
    %{iso_3166_1: :aq, name: "Antarctica"},
    %{iso_3166_1: :ag, name: "Antigua and Barbuda"},
    %{iso_3166_1: :ar, name: "Argentina"},
    %{iso_3166_1: :am, name: "Armenia"},
    %{iso_3166_1: :aw, name: "Aruba"},
    %{iso_3166_1: :au, name: "Australia"},
    %{iso_3166_1: :at, name: "Austria"},
    %{iso_3166_1: :az, name: "Azerbaijan"},
    %{iso_3166_1: :bs, name: "Bahamas"},
    %{iso_3166_1: :bh, name: "Bahrain"},
    %{iso_3166_1: :bd, name: "Bangladesh"},
    %{iso_3166_1: :bb, name: "Barbados"},
    %{iso_3166_1: :by, name: "Belarus"},
    %{iso_3166_1: :be, name: "Belgium"},
    %{iso_3166_1: :bz, name: "Belize"},
    %{iso_3166_1: :bj, name: "Benin"},
    %{iso_3166_1: :bm, name: "Bermuda"},
    %{iso_3166_1: :bt, name: "Bhutan"},
    %{iso_3166_1: :bo, name: "Bolivia"},
    %{iso_3166_1: :bq, name: "Bonaire, Saint Eustatius and Saba"},
    %{iso_3166_1: :ba, name: "Bosnia and Herzegovina"},
    %{iso_3166_1: :bw, name: "Botswana"},
    %{iso_3166_1: :bv, name: "Bouvet Island"},
    %{iso_3166_1: :br, name: "Brazil"},
    %{iso_3166_1: :io, name: "British Indian Ocean Territory"},
    %{iso_3166_1: :vg, name: "British Virgin Islands"},
    %{iso_3166_1: :bn, name: "Brunei"},
    %{iso_3166_1: :bg, name: "Bulgaria"},
    %{iso_3166_1: :bf, name: "Burkina Faso"},
    %{iso_3166_1: :bi, name: "Burundi"},
    %{iso_3166_1: :kh, name: "Cambodia"},
    %{iso_3166_1: :cm, name: "Cameroon"},
    %{iso_3166_1: :ca, name: "Canada"},
    %{iso_3166_1: :cv, name: "Cape Verde"},
    %{iso_3166_1: :ky, name: "Cayman Islands"},
    %{iso_3166_1: :cf, name: "Central African Republic"},
    %{iso_3166_1: :td, name: "Chad"},
    %{iso_3166_1: :cl, name: "Chile"},
    %{iso_3166_1: :cn, name: "China"},
    %{iso_3166_1: :cx, name: "Christmas Island"},
    %{iso_3166_1: :cc, name: "Cocos Islands"},
    %{iso_3166_1: :co, name: "Colombia"},
    %{iso_3166_1: :km, name: "Comoros"},
    %{iso_3166_1: :ck, name: "Cook Islands"},
    %{iso_3166_1: :cr, name: "Costa Rica"},
    %{iso_3166_1: :hr, name: "Croatia"},
    %{iso_3166_1: :cu, name: "Cuba"},
    %{iso_3166_1: :cw, name: "Curacao"},
    %{iso_3166_1: :cy, name: "Cyprus"},
    %{iso_3166_1: :cz, name: "Czech Republic"},
    %{iso_3166_1: :cd, name: "Democratic Republic of the Congo"},
    %{iso_3166_1: :dk, name: "Denmark"},
    %{iso_3166_1: :dj, name: "Djibouti"},
    %{iso_3166_1: :dm, name: "Dominica"},
    %{iso_3166_1: :do, name: "Dominican Republic"},
    %{iso_3166_1: :tl, name: "East Timor"},
    %{iso_3166_1: :ec, name: "Ecuador"},
    %{iso_3166_1: :eg, name: "Egypt"},
    %{iso_3166_1: :sv, name: "El Salvador"},
    %{iso_3166_1: :gq, name: "Equatorial Guinea"},
    %{iso_3166_1: :er, name: "Eritrea"},
    %{iso_3166_1: :ee, name: "Estonia"},
    %{iso_3166_1: :et, name: "Ethiopia"},
    %{iso_3166_1: :fk, name: "Falkland Islands"},
    %{iso_3166_1: :fo, name: "Faroe Islands"},
    %{iso_3166_1: :fj, name: "Fiji"},
    %{iso_3166_1: :fi, name: "Finland"},
    %{iso_3166_1: :fr, name: "France"},
    %{iso_3166_1: :gf, name: "French Guiana"},
    %{iso_3166_1: :pf, name: "French Polynesia"},
    %{iso_3166_1: :tf, name: "French Southern Territories"},
    %{iso_3166_1: :ga, name: "Gabon"},
    %{iso_3166_1: :gm, name: "Gambia"},
    %{iso_3166_1: :ge, name: "Georgia"},
    %{iso_3166_1: :de, name: "Germany"},
    %{iso_3166_1: :gh, name: "Ghana"},
    %{iso_3166_1: :gi, name: "Gibraltar"},
    %{iso_3166_1: :gr, name: "Greece"},
    %{iso_3166_1: :gl, name: "Greenland"},
    %{iso_3166_1: :gd, name: "Grenada"},
    %{iso_3166_1: :gp, name: "Guadeloupe"},
    %{iso_3166_1: :gu, name: "Guam"},
    %{iso_3166_1: :gt, name: "Guatemala"},
    %{iso_3166_1: :gg, name: "Guernsey"},
    %{iso_3166_1: :gn, name: "Guinea"},
    %{iso_3166_1: :gw, name: "Guinea-Bissau"},
    %{iso_3166_1: :gy, name: "Guyana"},
    %{iso_3166_1: :ht, name: "Haiti"},
    %{iso_3166_1: :hm, name: "Heard Island and McDonald Islands"},
    %{iso_3166_1: :hn, name: "Honduras"},
    %{iso_3166_1: :hk, name: "Hong Kong"},
    %{iso_3166_1: :hu, name: "Hungary"},
    %{iso_3166_1: :is, name: "Iceland"},
    %{iso_3166_1: :in, name: "India"},
    %{iso_3166_1: :id, name: "Indonesia"},
    %{iso_3166_1: :ir, name: "Iran"},
    %{iso_3166_1: :iq, name: "Iraq"},
    %{iso_3166_1: :ie, name: "Ireland"},
    %{iso_3166_1: :im, name: "Isle of Man"},
    %{iso_3166_1: :il, name: "Israel"},
    %{iso_3166_1: :it, name: "Italy"},
    %{iso_3166_1: :ci, name: "Ivory Coast"},
    %{iso_3166_1: :jm, name: "Jamaica"},
    %{iso_3166_1: :jp, name: "Japan"},
    %{iso_3166_1: :je, name: "Jersey"},
    %{iso_3166_1: :jo, name: "Jordan"},
    %{iso_3166_1: :kz, name: "Kazakhstan"},
    %{iso_3166_1: :ke, name: "Kenya"},
    %{iso_3166_1: :ki, name: "Kiribati"},
    %{iso_3166_1: :xk, name: "Kosovo"},
    %{iso_3166_1: :kw, name: "Kuwait"},
    %{iso_3166_1: :kg, name: "Kyrgyzstan"},
    %{iso_3166_1: :la, name: "Laos"},
    %{iso_3166_1: :lv, name: "Latvia"},
    %{iso_3166_1: :lb, name: "Lebanon"},
    %{iso_3166_1: :ls, name: "Lesotho"},
    %{iso_3166_1: :lr, name: "Liberia"},
    %{iso_3166_1: :ly, name: "Libya"},
    %{iso_3166_1: :li, name: "Liechtenstein"},
    %{iso_3166_1: :lt, name: "Lithuania"},
    %{iso_3166_1: :lu, name: "Luxembourg"},
    %{iso_3166_1: :mo, name: "Macao"},
    %{iso_3166_1: :mk, name: "Macedonia"},
    %{iso_3166_1: :mg, name: "Madagascar"},
    %{iso_3166_1: :mw, name: "Malawi"},
    %{iso_3166_1: :my, name: "Malaysia"},
    %{iso_3166_1: :mv, name: "Maldives"},
    %{iso_3166_1: :ml, name: "Mali"},
    %{iso_3166_1: :mt, name: "Malta"},
    %{iso_3166_1: :mh, name: "Marshall Islands"},
    %{iso_3166_1: :mq, name: "Martinique"},
    %{iso_3166_1: :mr, name: "Mauritania"},
    %{iso_3166_1: :mu, name: "Mauritius"},
    %{iso_3166_1: :yt, name: "Mayotte"},
    %{iso_3166_1: :mx, name: "Mexico"},
    %{iso_3166_1: :fm, name: "Micronesia"},
    %{iso_3166_1: :md, name: "Moldova"},
    %{iso_3166_1: :mc, name: "Monaco"},
    %{iso_3166_1: :mn, name: "Mongolia"},
    %{iso_3166_1: :me, name: "Montenegro"},
    %{iso_3166_1: :ms, name: "Montserrat"},
    %{iso_3166_1: :ma, name: "Morocco"},
    %{iso_3166_1: :mz, name: "Mozambique"},
    %{iso_3166_1: :mm, name: "Myanmar"},
    %{iso_3166_1: :na, name: "Namibia"},
    %{iso_3166_1: :nr, name: "Nauru"},
    %{iso_3166_1: :np, name: "Nepal"},
    %{iso_3166_1: :nl, name: "Netherlands"},
    %{iso_3166_1: :nc, name: "New Caledonia"},
    %{iso_3166_1: :nz, name: "New Zealand"},
    %{iso_3166_1: :ni, name: "Nicaragua"},
    %{iso_3166_1: :ne, name: "Niger"},
    %{iso_3166_1: :ng, name: "Nigeria"},
    %{iso_3166_1: :nu, name: "Niue"},
    %{iso_3166_1: :nf, name: "Norfolk Island"},
    %{iso_3166_1: :kp, name: "North Korea"},
    %{iso_3166_1: :mp, name: "Northern Mariana Islands"},
    %{iso_3166_1: :no, name: "Norway"},
    %{iso_3166_1: :om, name: "Oman"},
    %{iso_3166_1: :pk, name: "Pakistan"},
    %{iso_3166_1: :pw, name: "Palau"},
    %{iso_3166_1: :ps, name: "Palestinian Territory"},
    %{iso_3166_1: :pa, name: "Panama"},
    %{iso_3166_1: :pg, name: "Papua New Guinea"},
    %{iso_3166_1: :py, name: "Paraguay"},
    %{iso_3166_1: :pe, name: "Peru"},
    %{iso_3166_1: :ph, name: "Philippines"},
    %{iso_3166_1: :pn, name: "Pitcairn"},
    %{iso_3166_1: :pl, name: "Poland"},
    %{iso_3166_1: :pt, name: "Portugal"},
    %{iso_3166_1: :pr, name: "Puerto Rico"},
    %{iso_3166_1: :qa, name: "Qatar"},
    %{iso_3166_1: :cg, name: "Republic of the Congo"},
    %{iso_3166_1: :re, name: "Reunion"},
    %{iso_3166_1: :ro, name: "Romania"},
    %{iso_3166_1: :ru, name: "Russia"},
    %{iso_3166_1: :rw, name: "Rwanda"},
    %{iso_3166_1: :bl, name: "Saint Barthelemy"},
    %{iso_3166_1: :sh, name: "Saint Helena"},
    %{iso_3166_1: :kn, name: "Saint Kitts and Nevis"},
    %{iso_3166_1: :lc, name: "Saint Lucia"},
    %{iso_3166_1: :mf, name: "Saint Martin"},
    %{iso_3166_1: :pm, name: "Saint Pierre and Miquelon"},
    %{iso_3166_1: :vc, name: "Saint Vincent and the Grenadines"},
    %{iso_3166_1: :ws, name: "Samoa"},
    %{iso_3166_1: :sm, name: "San Marino"},
    %{iso_3166_1: :st, name: "Sao Tome and Principe"},
    %{iso_3166_1: :sa, name: "Saudi Arabia"},
    %{iso_3166_1: :sn, name: "Senegal"},
    %{iso_3166_1: :rs, name: "Serbia"},
    %{iso_3166_1: :sc, name: "Seychelles"},
    %{iso_3166_1: :sl, name: "Sierra Leone"},
    %{iso_3166_1: :sg, name: "Singapore"},
    %{iso_3166_1: :sx, name: "Sint Maarten"},
    %{iso_3166_1: :sk, name: "Slovakia"},
    %{iso_3166_1: :si, name: "Slovenia"},
    %{iso_3166_1: :sb, name: "Solomon Islands"},
    %{iso_3166_1: :so, name: "Somalia"},
    %{iso_3166_1: :za, name: "South Africa"},
    %{iso_3166_1: :gs, name: "South Georgia and the South Sandwich Islands"},
    %{iso_3166_1: :kr, name: "South Korea"},
    %{iso_3166_1: :ss, name: "South Sudan"},
    %{iso_3166_1: :es, name: "Spain"},
    %{iso_3166_1: :lk, name: "Sri Lanka"},
    %{iso_3166_1: :sd, name: "Sudan"},
    %{iso_3166_1: :sr, name: "Suriname"},
    %{iso_3166_1: :sj, name: "Svalbard and Jan Mayen"},
    %{iso_3166_1: :sz, name: "Swaziland"},
    %{iso_3166_1: :se, name: "Sweden"},
    %{iso_3166_1: :ch, name: "Switzerland"},
    %{iso_3166_1: :sy, name: "Syria"},
    %{iso_3166_1: :tw, name: "Taiwan"},
    %{iso_3166_1: :tj, name: "Tajikistan"},
    %{iso_3166_1: :tz, name: "Tanzania"},
    %{iso_3166_1: :th, name: "Thailand"},
    %{iso_3166_1: :tg, name: "Togo"},
    %{iso_3166_1: :tk, name: "Tokelau"},
    %{iso_3166_1: :to, name: "Tonga"},
    %{iso_3166_1: :tt, name: "Trinidad and Tobago"},
    %{iso_3166_1: :tn, name: "Tunisia"},
    %{iso_3166_1: :tr, name: "Turkey"},
    %{iso_3166_1: :tm, name: "Turkmenistan"},
    %{iso_3166_1: :tc, name: "Turks and Caicos Islands"},
    %{iso_3166_1: :tv, name: "Tuvalu"},
    %{iso_3166_1: :vi, name: "U.S. Virgin Islands"},
    %{iso_3166_1: :ug, name: "Uganda"},
    %{iso_3166_1: :ua, name: "Ukraine"},
    %{iso_3166_1: :ae, name: "United Arab Emirates"},
    %{iso_3166_1: :gb, name: "United Kingdom"},
    %{iso_3166_1: :us, name: "United States"},
    %{iso_3166_1: :um, name: "United States Minor Outlying Islands"},
    %{iso_3166_1: :uy, name: "Uruguay"},
    %{iso_3166_1: :uz, name: "Uzbekistan"},
    %{iso_3166_1: :vu, name: "Vanuatu"},
    %{iso_3166_1: :va, name: "Vatican"},
    %{iso_3166_1: :ve, name: "Venezuela"},
    %{iso_3166_1: :vn, name: "Vietnam"},
    %{iso_3166_1: :wf, name: "Wallis and Futuna"},
    %{iso_3166_1: :eh, name: "Western Sahara"},
    %{iso_3166_1: :ye, name: "Yemen"},
    %{iso_3166_1: :zm, name: "Zambia"},
    %{iso_3166_1: :zw, name: "Zimbabwe"}
  ]

  @country_codes Enum.map(@countries, & &1[:iso_3166_1])
  @country_names Enum.map(@countries, & &1[:name])

  def list(), do: @countries
  def list(:iso_3166_1), do: @country_codes
  def list(:name), do: @country_names
end
