//
//  Validations.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 03/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation


//MARK: -

enum ValidationError: LocalizedError {
    case invalidValue
    
    case userFullNameEmpty
    case userEmailEmpty
    case userEmailInvalid
    case userPasswordEmpty
    case userPasswordInvalid
    case userConfirmPasswordEmpty
    case userConfirmPasswordInvalid
    case userPasswordNotMatched

    case tripTitleEmpty
    case tripDateEmpty
    case tripImagesEmpty

    
    var errorDescription: String? {
        switch self {
        case .invalidValue                 : return Constant.enterInvalidValue
        
        case .userFullNameEmpty            : return Constant.enterFullName
        case .userEmailEmpty               : return Constant.enterEmail
        case .userEmailInvalid             : return Constant.enterValidEmail
        case .userPasswordEmpty            : return Constant.enterPassword
        case .userPasswordInvalid          : return Constant.enterValidPassword
        case .userConfirmPasswordEmpty     : return Constant.enterConfirmPassword
        case .userConfirmPasswordInvalid   : return Constant.enterValidConfirmPassword
        case .userPasswordNotMatched       : return Constant.enterCorrectPassword

        case .tripTitleEmpty               : return Constant.enterTitle
        case .tripDateEmpty                : return Constant.selectDate
        case .tripImagesEmpty              : return Constant.selectPhoto
        }
    }
}


//MARK: -

struct UserValidations
{
    func validateSignInRequest(request: LoginRequest?) -> ValidationResponse
    {
        do {
            let _ = try validateEmail(request?.email)
            let _ = try validatePassword(request?.password)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.userEmailEmpty {
            return ValidationResponse(error: ValidationError.userEmailEmpty, message: ValidationError.userEmailEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userEmailInvalid {
            return ValidationResponse(error: ValidationError.userEmailInvalid, message: ValidationError.userEmailInvalid.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordEmpty {
            return ValidationResponse(error: ValidationError.userPasswordEmpty, message: ValidationError.userPasswordEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordInvalid {
            return ValidationResponse(error: ValidationError.userPasswordInvalid, message: ValidationError.userPasswordInvalid.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateSignUpRequest(request: RegisterRequest?) -> ValidationResponse
    {
        do {
            let _ = try validateName(request?.name)
            let _ = try validateEmail(request?.email)
            let _ = try validatePassword(request?.password)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.userFullNameEmpty {
            return ValidationResponse(error: ValidationError.userFullNameEmpty, message: ValidationError.userFullNameEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userEmailEmpty {
            return ValidationResponse(error: ValidationError.userEmailEmpty, message: ValidationError.userEmailEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userEmailInvalid {
            return ValidationResponse(error: ValidationError.userEmailInvalid, message: ValidationError.userEmailInvalid.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordEmpty {
            return ValidationResponse(error: ValidationError.userPasswordEmpty, message: ValidationError.userPasswordEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordInvalid {
            return ValidationResponse(error: ValidationError.userPasswordInvalid, message: ValidationError.userPasswordInvalid.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateEditProfileRequest(request: EditProfileRequest?) -> ValidationResponse
    {
        do {
            let _ = try validateName(request?.name)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.userFullNameEmpty {
            return ValidationResponse(error: ValidationError.userFullNameEmpty, message: ValidationError.userFullNameEmpty.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateChangePasswordRequest(request: ChangePasswordRequest?) -> ValidationResponse
    {
        do {
            let _ = try validatePassword(request?.newPassword)
            let _ = try validateConfirmPassword(request?.confirmPassword)
            let _ = try validatePasswordMatch(request?.newPassword, request?.confirmPassword)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.userPasswordEmpty {
            return ValidationResponse(error: ValidationError.userPasswordEmpty, message: ValidationError.userPasswordEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordInvalid {
            return ValidationResponse(error: ValidationError.userPasswordInvalid, message: ValidationError.userPasswordInvalid.localizedDescription, isValid: false)
        } catch ValidationError.userConfirmPasswordEmpty {
            return ValidationResponse(error: ValidationError.userConfirmPasswordEmpty, message: ValidationError.userConfirmPasswordEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userConfirmPasswordInvalid {
            return ValidationResponse(error: ValidationError.userConfirmPasswordInvalid, message: ValidationError.userConfirmPasswordInvalid.localizedDescription, isValid: false)
        } catch ValidationError.userPasswordNotMatched {
            return ValidationResponse(error: ValidationError.userPasswordNotMatched, message: ValidationError.userPasswordNotMatched.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateForgotPasswordRequest(request: ForgotPasswordRequest?) -> ValidationResponse
    {
        do {
            let _ = try validateEmail(request?.email)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.userEmailEmpty {
            return ValidationResponse(error: ValidationError.userEmailEmpty, message: ValidationError.userEmailEmpty.localizedDescription, isValid: false)
        } catch ValidationError.userEmailInvalid {
            return ValidationResponse(error: ValidationError.userEmailInvalid, message: ValidationError.userEmailInvalid.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateName(_ name: String?) throws -> String
    {
        guard let value = name else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.userFullNameEmpty }
        return ""
    }
    
    
    func validateEmail(_ email: String?) throws -> String
    {
        guard let value = email else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.userEmailEmpty }
        guard Utils.validateEmail(value) else { throw ValidationError.userEmailInvalid }
        return ""
    }
    
    
    func validatePassword(_ password: String?) throws -> String
    {
        guard let value = password else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.userPasswordEmpty }
        guard Utils.validatePassword(value) else { throw ValidationError.userPasswordInvalid }
        return ""
    }
    
    
    func validateConfirmPassword(_ password: String?) throws -> String
    {
        guard let value = password else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.userConfirmPasswordEmpty }
        guard Utils.validatePassword(value) else { throw ValidationError.userConfirmPasswordInvalid }
        return ""
    }
    
    
    func validatePasswordMatch(_ nPassword: String?, _ cPassword: String?) throws -> String
    {
        guard let nvalue = nPassword, let cvalue = cPassword else { throw ValidationError.invalidValue }
        guard !nvalue.isEmpty else { throw ValidationError.userPasswordEmpty }
        guard !cvalue.isEmpty else { throw ValidationError.userConfirmPasswordEmpty }
        guard cvalue.isEqualToString(find: nvalue) else { throw ValidationError.userPasswordNotMatched }
        return ""
    }
}


//MARK: -

struct AddEditTripValidations
{
    func validateRequest(request: TripRequest?) -> ValidationResponse
    {
        do {
            let _ = try validateTitle(request?.title)
            let _ = try validateDate(request?.date)
            let _ = try validateImageSelection(request?.images)

            return ValidationResponse(error: nil, message: nil, isValid: true)

        } catch ValidationError.tripTitleEmpty {
            return ValidationResponse(error: ValidationError.tripTitleEmpty, message: ValidationError.tripTitleEmpty.localizedDescription, isValid: false)
        } catch ValidationError.tripDateEmpty {
            return ValidationResponse(error: ValidationError.tripDateEmpty, message: ValidationError.tripTitleEmpty.localizedDescription, isValid: false)
        } catch ValidationError.tripImagesEmpty {
            return ValidationResponse(error: ValidationError.tripImagesEmpty, message: ValidationError.tripTitleEmpty.localizedDescription, isValid: false)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
            return ValidationResponse(error: error as? ValidationError, message: error.localizedDescription, isValid: false)
       }
    }
    
    
    func validateTitle(_ title: String?) throws -> String
    {
        guard let value = title else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.tripTitleEmpty }
        return ""
    }
    
    
    func validateDate(_ date: String?) throws -> String
    {
        guard let value = date else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.tripDateEmpty }
        return ""
    }
    
    
    func validateImageSelection(_ images: [String]?) throws -> String
    {
        guard let value = images else { throw ValidationError.invalidValue }
        guard !value.isEmpty else { throw ValidationError.tripImagesEmpty }
        return ""
    }
}
