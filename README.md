# Rocket Launcher

A Rails fuel calculator for space travel. Enter a spaceship’s dry mass and a sequence of launches and landings; the app returns the total fuel required, including the fuel needed to carry that fuel.

There is no database. Mass and path live in the form and are calculated on submit.

## Features

- Set equipment mass in kilograms
- Build a travel path by adding or removing launches and landings
- Choose Earth, Moon, or Mars for each step (gravities 9.807, 1.62, and 3.711 m/s²)
- Enforce a valid route:
  - The first step may be a launch or a landing
  - After a launch, the next step must be a landing (any body)
  - After a landing, the next step must be a launch from that same body
- Calculate total fuel and a per-maneuver breakdown

The UI uses Hotwire (Turbo + Stimulus). Adding a path point is handled by `SpaceTravelController#add_path_point`; fuel is computed by `#calculate`.

## Fuel formula

Each maneuver is rounded down:

- **Launch:** `mass × gravity × 0.042 − 33`
- **Landing:** `mass × gravity × 0.033 − 42`

If the result is not positive, that maneuver needs no more fuel. Otherwise the extra fuel is treated as mass and the same formula is applied again until it reaches zero.

Later maneuvers must be carried during earlier ones, so the path is calculated from the last step back to the first.

Known totals:

| Mission | Path | Mass | Fuel |
| --- | --- | ---: | ---: |
| Apollo 11 | launch Earth, land Moon, launch Moon, land Earth | 28801 kg | 51898 kg |
| Mars | launch Earth, land Mars, launch Mars, land Earth | 14606 kg | 33388 kg |
| Passenger ship | launch Earth, land Moon, launch Moon, land Mars, launch Mars, land Earth | 75432 kg | 212161 kg |

## Requirements

- Ruby 3.3.6 (see `.ruby-version`)
- Bundler

## Setup and run

```bash
bundle install
bin/rails server
```

Or:

```bash
bin/setup
```

Open [http://localhost:3000](http://localhost:3000).

## Tests

```bash
bin/rails test
bin/rails test:system
```

Fuel totals for the three missions above live in `test/models/fuel_calculator_test.rb`. Path sequence rules are covered in `test/models/travel_path_test.rb`.
