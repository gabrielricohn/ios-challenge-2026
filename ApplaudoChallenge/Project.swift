import ProjectDescription

let project = Project(
    name: "ApplaudoChallenge",
    targets: [
        .target(
            name: "ApplaudoChallenge",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.ApplaudoChallenge",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "ApplaudoChallenge/Sources",
                "ApplaudoChallenge/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "ApplaudoChallengeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.ApplaudoChallengeTests",
            infoPlist: .default,
            buildableFolders: [
                "ApplaudoChallenge/Tests"
            ],
            dependencies: [.target(name: "ApplaudoChallenge")]
        ),
    ]
)
