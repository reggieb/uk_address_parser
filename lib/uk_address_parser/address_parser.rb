module UkAddressParser
  class AddressParser

    attr_accessor :address, :flat, :house_number, :building_name, :street, :street2, :street3, :town, :county
    def initialize(address)
      self.address = address
    end

    def parts
      comma_or_commas_with_empty_spaces = /\s?\,[\s\,]*/
      @parts ||= address.split(comma_or_commas_with_empty_spaces).collect(&:strip)
    end

    def build
      postcode
      build_county
      building_and_street
      build_town
      streets
    end

    def postcode
      @postcode || build_postcode
    end

    def build_postcode
      @postcode = parts.pop if postcode_pattern =~ parts.last
    end

    # Checking for something that looks like a postcode
    # This is not checking if the postcode is valid
    def postcode_pattern
      /^[0-9A-Z]{2,4}\s+[0-9A-Z]{3}$/
    end

    def build_county
      @county = parts.pop if counties.include?(parts.last)
    end

    def building_and_street
      case parts.first
      when number_and_known_street_ending
        @house_number = $1
        @street = $2
        parts.shift
      when known_street_ending_no_number
        if !building_name && looks_like_a_street?(parts[1])
          @building_name = parts.shift
          building_and_street
        else
          @street = parts.shift
        end
      when flat_number
        @flat = parts.shift
        building_and_street
      when number_and_any_street_name
        @house_number = $1
        @street = $2
        parts.shift
        if !building_name && looks_like_a_street?(parts[0])
          @building_name = @street
          @street = parts.shift
        end
      else
        unless building_name
          @building_name = parts.shift
          building_and_street
        end
      end
    end

    def number_and_known_street_ending
      /^(\d+\w?)\s([a-zA-Z\s\-\.\']+(#{street_endings.join('|')})$)/i
    end

    def known_street_ending_no_number
      /^([a-zA-Z\s\-\.\']+(#{street_endings.join('|')})$)/i
    end

    def flat_number
      /^Flat\s.*\d+.*/
    end

    def number_and_any_street_name
      /^(\d+\w?)\s([\w\s\-\.]+)$/i
    end

    def looks_like_a_street?(part)
      (number_and_any_street_name =~ part || known_street_ending_no_number =~ part)
    end

    def build_town
      @town = parts.pop unless parts.empty?
    end

    def streets
      return if parts.empty?
      @street = parts.shift unless street
      @street2 = parts.shift
      @street3 = parts.shift
      raise "unprocessed parts: #{parts}" unless parts.empty?
    end

    def details
      build unless parts.empty?
      {
        flat: flat,
        house_number: house_number,
        building_name: building_name,
        street: street,
        street2: street2,
        street3: street3,
        town: town,
        county: county,
        postcode: postcode
      }
    end

    def counties
      [
        'Avon', 'Bedfordshire', 'Berkshire', 'Borders', 'Buckinghamshire', 'Cambridgeshire', 'Central',
        'Cheshire', 'Cleveland', 'Clwyd', 'Cornwall', 'County Antrim', 'County Armagh', 'County Down',
        'County Fermanagh', 'County Londonderry', 'County Tyrone', 'Cumbria', 'Derbyshire', 'Devon',
        'Dorset', 'Dumfries and Galloway', 'Durham', 'Dyfed', 'East Sussex', 'Essex', 'Fife',
        'Gloucestershire', 'Grampian', 'Greater Manchester', 'Gwent', 'Gwynedd County', 'Hampshire',
        'Herefordshire', 'Hertfordshire', 'Highlands and Islands', 'Humberside', 'Isle of Wight',
        'Kent', 'Lancashire', 'Leicestershire', 'Lincolnshire', 'Lothian', 'Merseyside', 'Mid Glamorgan',
        'Norfolk', 'North Yorkshire', 'Northamptonshire', 'Northumberland', 'Nottinghamshire', 'Oxfordshire',
        'Powys', 'Rutland', 'Shropshire', 'Somerset', 'South Glamorgan', 'South Yorkshire', 'Staffordshire',
        'Strathclyde', 'Suffolk', 'Surrey', 'Tayside', 'Tyne and Wear', 'Warwickshire', 'West Glamorgan',
        'West Midlands', 'West Sussex', 'West Yorkshire', 'Wiltshire', 'Worcestershire'
      ]
    end

    def street_endings
      [
        'ALLEE', 'ALLEY', 'ALLY', 'ALY', 'ANEX', 'ANNEX', 'ANNX', 'ANX', 'ARC', 'ARCADE', 'AV', 'AVE', 'AVEN',
        'AVENU', 'AVENUE', 'AVN', 'AVNUE', 'BAYOO', 'BAYOU', 'BCH', 'BEACH', 'BEND', 'BND', 'BLF', 'BLUF', 'BLUFF',
        'BLUFFS', 'BOT', 'BTM', 'BOTTM', 'BOTTOM', 'BLVD', 'BOUL', 'BOULEVARD', 'BOULV', 'BR', 'BRNCH', 'BRANCH',
        'BRDGE', 'BRG', 'BRIDGE', 'BRK', 'BROOK', 'BROOKS', 'BURG', 'BURGS', 'BYP', 'BYPA', 'BYPAS', 'BYPASS',
        'BYPS', 'CAMP', 'CP', 'CMP', 'CANYN', 'CANYON', 'CNYN', 'CAPE', 'CPE', 'CAUSEWAY', 'CAUSWA', 'CSWY',
        'CEN', 'CENT', 'CENTER', 'CENTR', 'CENTRE', 'CNTER', 'CNTR', 'CTR', 'CENTERS', 'CIR', 'CIRC', 'CIRCL',
        'CIRCLE', 'CRCL', 'CRCLE', 'CIRCLES', 'CLF', 'CLIFF', 'CLFS', 'CLIFFS', 'CL', 'CLOSE', 'CLB', 'CLUB', 'COMMON', 'COMMONS',
        'COR', 'CORNER', 'CORNERS', 'CORS', 'COURSE', 'CRSE', 'COURT', 'CT', 'COURTS', 'CTS', 'COVE', 'CV', 'COVES',
        'CREEK', 'CRK', 'CRESCENT', 'CRES', 'CRSENT', 'CRSNT', 'CREST', 'CROSSING', 'CRSSNG', 'XING', 'CROSSROAD',
        'CROSSROADS', 'CURVE', 'DALE', 'DL', 'DAM', 'DM', 'DIV', 'DIVIDE', 'DV', 'DVD', 'DR', 'DRIV', 'DRIVE', 'DRV',
        'DRIVES', 'EST', 'ESTATE', 'ESTATES', 'ESTS', 'EXP', 'EXPR', 'EXPRESS', 'EXPRESSWAY', 'EXPW', 'EXPY', 'EXT',
        'EXTENSION', 'EXTN', 'EXTNSN', 'EXTS', 'FALL', 'FALLS', 'FLS', 'FERRY', 'FRRY', 'FRY', 'FIELD', 'FLD', 'FIELDS',
        'FLDS', 'FLAT', 'FLT', 'FLATS', 'FLTS', 'FORD', 'FRD', 'FORDS', 'FOREST', 'FORESTS', 'FRST', 'FORG', 'FORGE',
        'FRG', 'FORGES', 'FORK', 'FRK', 'FORKS', 'FRKS', 'FORT', 'FRT', 'FT', 'FREEWAY', 'FREEWY', 'FRWAY', 'FRWY',
        'FWY', 'GARDEN', 'GARDN', 'GRDEN', 'GRDN', 'GARDENS', 'GDNS', 'GRDNS', 'GATEWAY', 'GATEWY', 'GATWAY', 'GTWAY',
        'GTWY', 'GLEN', 'GLN', 'GLENS', 'GREEN', 'GRN', 'GREENS', 'GROV', 'GROVE', 'GRV', 'GROVES', 'HARB', 'HARBOR',
        'HARBR', 'HBR', 'HRBOR', 'HARBORS', 'HAVEN', 'HVN', 'HT', 'HTS', 'HIGHWAY', 'HIGHWY', 'HIWAY', 'HIWY', 'HWAY',
        'HWY', 'HILL', 'HL', 'HILLS', 'HLS', 'HLLW', 'HOLLOW', 'HOLLOWS', 'HOLW', 'HOLWS', 'INLT', 'INLET', 'IS', 'ISLAND',
        'ISLND', 'ISLANDS', 'ISLNDS', 'ISS', 'ISLE', 'ISLES', 'JCT', 'JCTION', 'JCTN', 'JUNCTION', 'JUNCTN', 'JUNCTON',
        'JCTNS', 'JCTS', 'JUNCTIONS', 'KEY', 'KY', 'KEYS', 'KYS', 'KNL', 'KNOL', 'KNOLL', 'KNLS', 'KNOLLS', 'LK',
        'LAKE', 'LKS', 'LAKES', 'LAND', 'LANDING', 'LNDG', 'LNDNG', 'LANE', 'LN', 'LGT', 'LIGHT', 'LIGHTS', 'LF',
        'LOAF', 'LCK', 'LOCK', 'LCKS', 'LOCKS', 'LDG', 'LDGE', 'LODG', 'LODGE', 'LOOP', 'LOOPS', 'MALL', 'MNR', 'MANOR',
        'MANORS', 'MNRS', 'MEADOW', 'MDW', 'MDWS', 'MEADOWS', 'MEDOWS', 'MEWS', 'MILL', 'MILLS', 'MISSN', 'MSSN',
        'MOTORWAY', 'MNT', 'MT', 'MOUNT', 'MNTAIN', 'MNTN', 'MOUNTAIN', 'MOUNTIN', 'MTIN', 'MTN', 'MNTNS', 'MOUNTAINS',
        'NCK', 'NECK', 'ORCH', 'ORCHARD', 'ORCHRD', 'OVAL', 'OVL', 'OVERPASS', 'PARADE' 'PARK', 'PRK', 'PARKS', 'PARKWAY',
        'PARKWY', 'PKWAY', 'PKWY', 'PKY', 'PARKWAYS', 'PKWYS', 'PASS', 'PASSAGE', 'PATH', 'PATHS', 'PIKE', 'PIKES',
        'PINE', 'PINES', 'PNES', 'PLACE', 'PL', 'PLAIN', 'PLN', 'PLAINS', 'PLNS', 'PLAZA', 'PLZ', 'PLZA', 'POINT', 'PT', 'POINTS',
        'PTS', 'PORT', 'PRT', 'PORTS', 'PRTS', 'PR', 'PRAIRIE', 'PRR', 'RAD', 'RADIAL', 'RADIEL', 'RADL', 'RAMP', 'RANCH',
        'RANCHES', 'RNCH', 'RNCHS', 'RAPID', 'RPD', 'RAPIDS', 'RPDS', 'REST', 'RST', 'RDG', 'RDGE', 'RIDGE', 'RDGS',
        'RIDGES', 'RIV', 'RIVER', 'RVR', 'RIVR', 'RD', 'ROAD', 'ROADS', 'RDS', 'ROUTE', 'ROW', 'RUE', 'RUN', 'SHL',
        'SHOAL', 'SHLS', 'SHOALS', 'SHOAR', 'SHORE', 'SHR', 'SHOARS', 'SHORES', 'SHRS', 'SKYWAY', 'SPG', 'SPNG', 'SPRING',
        'SPRNG', 'SPGS', 'SPNGS', 'SPRINGS', 'SPRNGS', 'SPUR', 'SPURS', 'SQ', 'SQR', 'SQRE', 'SQU', 'SQUARE', 'SQRS',
        'SQUARES', 'STA', 'STATION', 'STATN', 'STN', 'STRA', 'STRAV', 'STRAVEN', 'STRAVENUE', 'STRAVN', 'STRVN',
        'STRVNUE', 'STREAM', 'STREME', 'STRM', 'STREET', 'STRT', 'ST', 'STR', 'STREETS', 'SMT', 'SUMIT', 'SUMITT',
        'SUMMIT', 'TER', 'TERR', 'TERRACE', 'THROUGHWAY', 'TRACE', 'TRACES', 'TRCE', 'TRACK', 'TRACKS', 'TRAK', 'TRK',
        'TRKS', 'TRAFFICWAY', 'TRAIL', 'TRAILS', 'TRL', 'TRLS', 'TRAILER', 'TRLR', 'TRLRS', 'TUNEL', 'TUNL', 'TUNLS',
        'TUNNEL', 'TUNNELS', 'TUNNL', 'TRNPK', 'TURNPIKE', 'TURNPK', 'UNDERPASS', 'UN', 'UNION', 'UNIONS', 'VALLEY',
        'VALLY', 'VLLY', 'VLY', 'VALLEYS', 'VLYS', 'VDCT', 'VIA', 'VIADCT', 'VIADUCT', 'VIEW', 'VW', 'VIEWS', 'VWS',
        'VILL', 'VILLAG', 'VILLAGE', 'VILLG', 'VILLIAGE', 'VLG', 'VILLAGES', 'VLGS', 'VILLE', 'VL', 'VIS', 'VIST',
        'VISTA', 'VST', 'VSTA', 'WALK', 'WALKS', 'WALL', 'WY', 'WAY', 'WAYS', 'WELL', 'WELLS', 'WLS'
      ]
    end
  end
end
