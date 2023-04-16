# ❝ Swift FavQs

Unofficial iOS app client for [FavQs](https://favqs.com/api) API. I have been working on this project during my spare time and I'm using it mostly as a playground to play with Swift async/await and latest version of [TCA](https://github.com/pointfreeco/swift-composable-architecture) against a real world API. It's far from being production ready so many features are missing or not supported yet. 

# 🏛️ Architecture

The application follows a clean architecture approach and exposes these layers:

- **Domain**

    No dependencies, contains models and repository interfaces.

- **UseCase**
   
    Very close to Domain and depends on Domain and [swift-dependecies](https://github.com/pointfreeco/swift-dependencies) for repository registration and DI. It exposes a bunch of functions that can be called to execute the app use cases. Main reasons to have this layer are to have the screaming architecture part of the Domain and to avoid having features using directly the repositories.

- **Persistence**
	
    This layer depends only on Domain and is the space for implementing the live repository interfaces.

	- **Networking**
		
		Implements the repository interfaces using URLSession and calls FavQs API. Internally maps DTOs with JSON details to Domain entities.

- **Presentation**

    This layer exist only logically and contains other three sub-layers. Code in this layer depends on Domain, UseCase, and TCA. The sub-layers are:

    - **Feature**
        
        Contains the TCA reducers/features. This layer exist to reuse logic in both SwftUI and UIKit environments so no UI framework dependency is allowed.

    - **SwiftUIPresentation**

		Depends on Feature and has SwiftUI implementation of the UI.

	- **UIKitImplementation**

		Similar to SwiftUIPresentation but UIKit implementation of the UI.

- **Application**
	
	The composition root. Contains the XCode project that depends on the other layers and exposes 2 targets to run the app using SwiftUI or UIKit presentation. It's also the layer from where live repositories injection happens.

### Architecture diagram
[![](https://mermaid.ink/img/pako:eNqlWG1v2jAQ_ivIn1IJygobbfkwqWo1qepeurX9sjBNJjlIVrAj27RDFf99TmLASc4xXT_Fvnuee3N8R3ghEY-BjMlc0CzpfP4xYRPW6cjVtBRkNHqkc_h9xZc0ZWH5-JVDOlvdreDxKlIGEmwxRyVIUTEHhfCBxQ5fDxIuqYTQPHFvRhnsUFV_uI2q8h6kkqG98QQmn9OZiiHTCGBRCjIsJD1b5KiNhdAVsvFH7T4_AVUrAaF54uaNMtihqsXAbVSVZTHszSHFiPgy45JOF0BFlKQKosJRWZa9smdr8RQud-ALCxuEuNxXtbs8gIfrWwESmKIq5SxEZHgoCDBA2dUqv86nm1SehEtxyKlIRjOZcKU0IWVzcxxbac-IHckb1H0J0olXBb7KP1zfpKpSg4bEcaHrsABh1i75wb5cBNMCULGn0hfikTJ6A2t5zRSIGY10P8CEeLoYMsD51aRf5_eQ-C22L1Y7QmdcdXvuGG5ByFQq3QkhtNZ4FF9BPXPxWLyU-3Utir3CxhxwZ_gTCKt3bbd4KN-MNgi3K-e1EPwP5B2aPn2Xf_NZm0vCYnu829c6cq409z-0NwiseHXD_bKaKjqhO73ex-pYRqBmKtpYI8rBVQluEMG0DMUmo7iDDv_4-LPBRmSZtUEHzR4H15UogmlWzJ6vjnD9w8gmImrLnYfcyMGDbxbVNaXeFOLeQvtswl7beievHEddab90bcTmS92GblYJny__Hdob6oPNCTsOTN9qBidb0fugrX72Ldwm76WWHxzaOLkazNHXvXbRVO1Wjfa7RsvwEJAm5mGgpfGR2i-oj400ud00OrwKTrijBk68uwJOStvl8zDL3EmXLEHotGL9If2SsydEJbCECRnr5Yxr22pCukZTbHJFAosF7-hwF_GETNhG26Erxe_WLCLjGV1I6JJVFlMFVynVvyeWO-mC0xgEGb8Qtc6Kz3f900nTI85m6TyXr8RCixOlMjnu93P18TxVyWp6rD_L-jKNEypU8nQ-6o8GozM6GMLodEg_DIdxND05P5sN3p_M4tN3JwNKNpsugThVXHwp_yso_jLokoyyn5xvg9r8A1O5ARI?type=png)](https://mermaid.live/edit#pako:eNqlWG1v2jAQ_ivIn1IJygobbfkwqWo1qepeurX9sjBNJjlIVrAj27RDFf99TmLASc4xXT_Fvnuee3N8R3ghEY-BjMlc0CzpfP4xYRPW6cjVtBRkNHqkc_h9xZc0ZWH5-JVDOlvdreDxKlIGEmwxRyVIUTEHhfCBxQ5fDxIuqYTQPHFvRhnsUFV_uI2q8h6kkqG98QQmn9OZiiHTCGBRCjIsJD1b5KiNhdAVsvFH7T4_AVUrAaF54uaNMtihqsXAbVSVZTHszSHFiPgy45JOF0BFlKQKosJRWZa9smdr8RQud-ALCxuEuNxXtbs8gIfrWwESmKIq5SxEZHgoCDBA2dUqv86nm1SehEtxyKlIRjOZcKU0IWVzcxxbac-IHckb1H0J0olXBb7KP1zfpKpSg4bEcaHrsABh1i75wb5cBNMCULGn0hfikTJ6A2t5zRSIGY10P8CEeLoYMsD51aRf5_eQ-C22L1Y7QmdcdXvuGG5ByFQq3QkhtNZ4FF9BPXPxWLyU-3Utir3CxhxwZ_gTCKt3bbd4KN-MNgi3K-e1EPwP5B2aPn2Xf_NZm0vCYnu829c6cq409z-0NwiseHXD_bKaKjqhO73ex-pYRqBmKtpYI8rBVQluEMG0DMUmo7iDDv_4-LPBRmSZtUEHzR4H15UogmlWzJ6vjnD9w8gmImrLnYfcyMGDbxbVNaXeFOLeQvtswl7beievHEddab90bcTmS92GblYJny__Hdob6oPNCTsOTN9qBidb0fugrX72Ldwm76WWHxzaOLkazNHXvXbRVO1Wjfa7RsvwEJAm5mGgpfGR2i-oj400ud00OrwKTrijBk68uwJOStvl8zDL3EmXLEHotGL9If2SsydEJbCECRnr5Yxr22pCukZTbHJFAosF7-hwF_GETNhG26Erxe_WLCLjGV1I6JJVFlMFVynVvyeWO-mC0xgEGb8Qtc6Kz3f900nTI85m6TyXr8RCixOlMjnu93P18TxVyWp6rD_L-jKNEypU8nQ-6o8GozM6GMLodEg_DIdxND05P5sN3p_M4tN3JwNKNpsugThVXHwp_yso_jLokoyyn5xvg9r8A1O5ARI)
Generated using [dependecy-graph](https://github.com/simonbs/dependency-graph).

# 🚀 Getting Started

Only dependency that needs some manual steps is [Arkana](https://github.com/rogerluan/arkana) in the Networking implementation of the Persistence layer. 
You will need to install it and provide a FavQs API key in the `Persistence/Sources/Networking/.env` file (copy existing `.env.template` and rename it) to use the live repositories implementation. 
Then run `bundle exec arkana` (from `Persistence/Sources/Networking`) and you should be good to go.

# 🧑‍💻 Contributing

Contribution are welcome, especially if you notice that I'm doing something completely wrong! If you would like to contribute feel free to raise issues or open pull requests.